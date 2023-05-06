using System.Globalization;
using FluentValidation;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using Serilog;
using VolumeVaultInfra.Book.Context;
using VolumeVaultInfra.Book.Controllers;
using VolumeVaultInfra.Book.Exceptions;
using VolumeVaultInfra.Book.Models.Book;
using VolumeVaultInfra.Book.Repositories;
using VolumeVaultInfra.Book.Utils;
using VolumeVaultInfra.Book.Validators;
using ILogger = Serilog.ILogger;
using Prometheus;
using VolumeVaultInfra.Book.Endpoints;
using VolumeVaultInfra.Book.Filters;
using VolumeVaultInfra.Book.Models.Delegates;
using VolumeVaultInfra.Book.Services;
using VolumeVaultInfra.Book.Services.Metrics;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

CultureInfo.CurrentUICulture = CultureInfo.GetCultureInfo("en-US");
CultureInfo.CurrentCulture = CultureInfo.GetCultureInfo("en-US");
CultureInfo.DefaultThreadCurrentCulture = CultureInfo.GetCultureInfo("en-US");
CultureInfo.DefaultThreadCurrentUICulture = CultureInfo.GetCultureInfo("en-US");

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.AddSecurityDefinition("API Key", new()
    {
        Description = "API Key for login and signin requests",
        Type = SecuritySchemeType.ApiKey,
        Name = ProgramConsts.API_KEY_REQUEST_HEADER,
        In = ParameterLocation.Header,
        Scheme = "ApiKeyScheme"
    });
    options.AddSecurityRequirement(new()
    {
        {
            new()
            {
                Reference = new()
                {
                    Type = ReferenceType.SecurityScheme
                }
            },
            Array.Empty<string>()
        }
    });
});

ILogger logger = new LoggerConfiguration()
    .Enrich.WithMachineName()
    .WriteTo.Console()
    .Enrich.WithProperty("Environment", EnvVariableConsts.ASPNETCORE_ENVIRONMENT)
    .ReadFrom.Configuration(builder.Configuration)
    .CreateLogger();
builder.Logging.ClearProviders();
builder.Logging.AddSerilog(logger);
builder.Host.UseSerilog(logger);

#region General Services
builder.Services.AddDbContext<DatabaseContext>(optionsBuilder =>
{
    string? connString = builder.Environment.IsDevelopment() ?
        builder.Configuration.GetConnectionString("MySqlConnectionString") : 
        EnvironmentVariables.GetMySqlConnectionString();
    
    if(string.IsNullOrEmpty(connString))
        throw new EnvironmentVariableNotProvidedException(EnvVariableConsts.MY_SQL_CONNECTION_STRING);

    optionsBuilder.UseMySQL(connString);
});
builder.Services.AddHealthChecks()
    .AddCheck<HealthCheckService>(nameof(HealthCheckService))
    .ForwardToPrometheus();

builder.Services.AddScoped<IBookRepository, BookRepository>();
builder.Services.AddScoped<IStatsRepository, StatsRepository>();
builder.Services.AddScoped<IBookSearchRepository, BookSearchRepository>();
builder.Services.AddScoped<IBookController, BookController>();
builder.Services.AddScoped<IStatsController, StatsController>();
builder.Services.AddScoped<IBookControllerMetrics, BookControllerMetrics>();
#endregion

#region Validation Services
builder.Services.AddScoped<IValidator<BookWriteModel>, BookWriteModelValidator>();
builder.Services.AddScoped<IValidator<BookUpdateModel>, BookUpdateModelValidator>();
#endregion

WebApplication app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

using (IServiceScope scope = app.Services.CreateScope())
{
    DatabaseContext context = scope.ServiceProvider
        .GetRequiredService<DatabaseContext>();

    context.Database.EnsureCreated();
    
    if (context.Database.GetPendingMigrations().Any())
        context.Database.Migrate();
}

using (IServiceScope scope = app.Services.CreateScope())
{
    IBookSearchRepository repository = scope.ServiceProvider
        .GetRequiredService<IBookSearchRepository>();
    await repository.EnsureCreatedAndReady();
}

app.UseStaticFiles();
app.UseRouting();

app.UseHttpMetrics();

app.UseAuthentication();
app.UseAuthorization();

#region SystemEndpoints
#pragma warning disable ASP0014
app.UseEndpoints(endpointOptions => endpointOptions.MapMetrics());
#pragma warning restore ASP0014
#endregion

RouteGroupBuilder bookGroup = app.MapGroup("book")
    .WithTags("book")
    .AddEndpointFilter<ApiKeyFilter>()
    .RequireAuthorization(PolicyAuthDelegateTemplates.JWTRequiredIdClaimPolicy);
bookGroup.MapBookEndpoints();

RouteGroupBuilder statsGroup = app.MapGroup("stats")
    .WithTags("stats")
    .AddEndpointFilter<ApiKeyFilter>()
    .RequireAuthorization(PolicyAuthDelegateTemplates.JWTRequiredIdClaimPolicy);
statsGroup.MapStatsEndpoints();

RouteGroupBuilder utilsGroup = app.MapGroup("utils")
    .WithTags("utils")
    .AddEndpointFilter<ApiKeyFilter>();
utilsGroup.MapUtilsEndpoints();

app.Run();