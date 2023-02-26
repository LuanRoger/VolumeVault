using System.Globalization;
using System.Text;
using FluentValidation;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using MongoDB.Driver;
using Serilog;
using VolumeVaultInfra.Context;
using VolumeVaultInfra.Controllers;
using VolumeVaultInfra.Exceptions;
using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.User;
using VolumeVaultInfra.Repositories;
using VolumeVaultInfra.Services.Jwt;
using VolumeVaultInfra.Utils;
using VolumeVaultInfra.Validators;
using ILogger = Serilog.ILogger;
using Prometheus;
using VolumeVaultInfra.Endpoints;
using VolumeVaultInfra.Filters;
using VolumeVaultInfra.Models.Delegates;
using VolumeVaultInfra.Services;
using VolumeVaultInfra.Services.Metrics;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.AddSecurityDefinition("API Key", new()
    {
        Description = "API Key for login and sigin requests",
        Type = SecuritySchemeType.ApiKey,
        Name = ProgramConsts.API_KEY_REQUEST_HEADER,
        In = ParameterLocation.Header,
        Scheme = "ApiKeyScheme"
    });
});

CultureInfo.CurrentUICulture = CultureInfo.GetCultureInfo("en-US");
CultureInfo.CurrentCulture = CultureInfo.GetCultureInfo("en-US");
CultureInfo.DefaultThreadCurrentCulture = CultureInfo.GetCultureInfo("en-US");
CultureInfo.DefaultThreadCurrentUICulture = CultureInfo.GetCultureInfo("en-US");

ILogger logger = new LoggerConfiguration()
    .Enrich.WithMachineName()
    .WriteTo.MongoDBBson(configurations =>
    {
        string mongoConnStringHolder = builder.Configuration
            .GetConnectionString("MongoDBConnectionString")!;
        string mongoConnString = builder.Environment.IsDevelopment() ? mongoConnStringHolder : 
            EnvironmentVariables.FormatVvMongoConnectionString(mongoConnStringHolder);
        
        MongoClient loggerClient = new(mongoConnString);
        IMongoDatabase loggerDatabase = loggerClient
            .GetDatabase(EnvironmentVariables.GetVvMongoDbName());
        
        configurations.SetMongoDatabase(loggerDatabase);
    })
    .WriteTo.Console()
    .Enrich.WithProperty("Environment", EnvVariableConsts.ASPNETCORE_ENVIRONMENT)
    .ReadFrom.Configuration(builder.Configuration)
    .CreateLogger();
builder.Logging.ClearProviders();
builder.Logging.AddSerilog(logger);
builder.Host.UseSerilog(logger);

#region General Services
builder.Services.AddHealthChecks()
    .AddCheck<HealthCheckService>(nameof(HealthCheckService))
    .ForwardToPrometheus();
builder.Services.AddDbContext<DatabaseBaseContext, DatabaseContext>(optionsBuilder =>
{
    if(builder.Environment.IsDevelopment())
    {
        optionsBuilder.UseNpgsql(builder.Configuration
            .GetConnectionString("PostgresConnectionString")!);
        return;
    }
    
    string? connStringHolder = builder.Configuration
        .GetConnectionString("PostgresConnectionString");
    if(string.IsNullOrEmpty(connStringHolder))
        throw new RequiredConfigurationException("PostgresConnectionString");
    
    string connString = EnvironmentVariables.FormatVvPostgresConnectionString(connStringHolder); 
    optionsBuilder.UseNpgsql(connString);
});
builder.Services.AddSingleton<IMongoClient, MongoClient>(_ =>
{
    if(builder.Environment.IsDevelopment())
        return new(builder.Configuration.GetConnectionString("MongoDBConnectionString")!);
    
    string connStringHolder = builder.Configuration.GetConnectionString("MongoDBConnectionString")!;
    if(string.IsNullOrEmpty(connStringHolder))
        throw new RequiredConfigurationException("MongoDBConnectionString");
    
    string connString = EnvironmentVariables
        .FormatVvMongoConnectionString(connStringHolder);
    return new(connString);
});
builder.Services.AddSingleton<JwtService>(_ =>
{
    string? jwtSymetricKey = EnvironmentVariables.GetSymmetricKey();
    if(jwtSymetricKey is null)
        throw new(EnvVariableConsts.JWT_SYMMETRIC_KEY);
    
    return new(jwtSymetricKey);
});

builder.Services.AddScoped<IUserRepository, UserRepository>();
builder.Services.AddScoped<IBookRepository, BookRepository>();
builder.Services.AddScoped<IBookSearchRepository, BookSearchRepository>(provider =>
{
    string? secundaryDbName = EnvironmentVariables.GetVvMongoDbName();
    if(secundaryDbName is null)
        throw new EnvironmentVariableNotProvidedException(EnvVariableConsts.VV_MONGO_DB_NAME);
    
    return new(provider.GetRequiredService<IMongoClient>(), secundaryDbName);
});
    builder.Services.AddScoped<IUserController, UserController>();
builder.Services.AddScoped<IBookController, BookController>();
builder.Services.AddScoped<IBookControllerMetrics, BookControllerMetrics>();
builder.Services.AddScoped<IUserControllerMetrics, UserControllerMetrics>();
#endregion

#region Validation Services
builder.Services.AddScoped<IValidator<UserWriteModel>, UserWriteModelValidator>();
builder.Services.AddScoped<IValidator<BookWriteModel>, BookWriteModelValidator>();
builder.Services.AddScoped<IValidator<BookUpdateModel>, BookUpdateModelValidator>();
#endregion

builder.Services.AddAuthentication(options =>
{
    options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
    .AddJwtBearer(options =>
    {
        string? jwtSymmetricKey = EnvironmentVariables.GetSymmetricKey();
        if(string.IsNullOrEmpty(jwtSymmetricKey))
            throw new EnvironmentVariableNotProvidedException(EnvVariableConsts.JWT_SYMMETRIC_KEY);
        
        options.TokenValidationParameters = new()
        {
            ValidateIssuer = true,
            ValidateLifetime = true,
            ValidateAudience = true,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSymmetricKey)),
            ValidAlgorithms = new [] { SecurityAlgorithms.HmacSha256Signature },
            ValidAudience = JwtServiceConsts.jwtAudience,
            ValidIssuer = JwtServiceConsts.jwtIssuer
        };
    });
builder.Services.AddAuthorization();

WebApplication app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

using (IServiceScope scope = app.Services.CreateScope())
{
    DatabaseContext? context = scope.ServiceProvider.GetService<DatabaseContext>();
    context?.Database.EnsureCreated();
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

#region UserEndpoint
// The user endpoint use the API Key filter to authenticate, this is to eliminate anonymous request.
// Just validate requests from trusted clients.
RouteGroupBuilder authGroup = app.MapGroup("auth")
    .WithTags("auth")
    .AddEndpointFilter<ApiKeyFilter>();
authGroup.MapAuthEndpoints();
#endregion

#region BooksEndpoint
RouteGroupBuilder bookGroup = app.MapGroup("book")
    .WithTags("book")
    .AddEndpointFilter<ApiKeyFilter>()
    .RequireAuthorization(PolicyAuthDelegateTemplates.JWTRequiredIdClaimPolicy);
bookGroup.MapBookEndpoints();
#endregion

#region UtilsEndpoint
RouteGroupBuilder utilsGroup = app.MapGroup("utils")
    .WithTags("utils")
    .AddEndpointFilter<ApiKeyFilter>();
utilsGroup.MapUtilsEndpoints();
#endregion

app.Run();