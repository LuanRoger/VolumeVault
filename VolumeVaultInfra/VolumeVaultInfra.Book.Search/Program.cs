using Asp.Versioning.Builder;
using FluentValidation;
using Meilisearch;
using Serilog;
using VolumeVaultInfra.Book.Search.Controllers;
using VolumeVaultInfra.Book.Search.Endpoints;
using VolumeVaultInfra.Book.Search.Exceptions;
using VolumeVaultInfra.Book.Search.Filters;
using VolumeVaultInfra.Book.Search.Middleware.Versioning;
using VolumeVaultInfra.Book.Search.Models;
using VolumeVaultInfra.Book.Search.Repositories;
using VolumeVaultInfra.Book.Search.Utils.EnviromentVars;
using VolumeVaultInfra.Book.Search.Validators;
using ILogger = Serilog.ILogger;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

ILogger logger = new LoggerConfiguration()
    .Enrich.WithMachineName()
    .WriteTo.Console()
    .Enrich.WithEnvironmentName()
    .CreateLogger();
builder.Logging.ClearProviders();
builder.Logging.AddSerilog(logger);
builder.Host.UseSerilog(logger);

builder.Services.AddSingleton<MeilisearchClient>(_ =>
{
    string? meilisearchMasterKey = EnvironmentVariables.GetMeiliseachMasterKey();
    string? meilisearchHost = EnvironmentVariables.GetMeiliSearchHost();
    if(string.IsNullOrEmpty(meilisearchMasterKey))
        throw new EnvironmentVariableNotProvidedException(EnvVariablesConsts.MEILISEARCH_MASTER_KEY);
    if(meilisearchHost is null)
        throw new EnvironmentVariableNotProvidedException(EnvVariablesConsts.MEILISEARCH_HOST);
    
    return new(meilisearchHost, meilisearchMasterKey);
});

builder.Services.AddScoped<IBookSearchRepository, BookSearchRepository>();
builder.Services.AddScoped<IValidator<BookSearchModel>, BookSearchModelValidator>();
builder.Services.AddScoped<IValidator<BookSearchRequest>, BookSearchRequestValidator>();

builder.Services.AddScoped<IBookSearchController, BookSearchController>();

builder.Services.AddApiVersioningOptions();

WebApplication app = builder.Build();

ApiVersionSet versionSet = ApiVersions.CreateVersionSet(app);
using (IServiceScope scope = app.Services.CreateScope())
{
    IBookSearchRepository repository = scope.ServiceProvider
        .GetRequiredService<IBookSearchRepository>();
    await repository.EnsureCreatedAndReady();
}

RouteGroupBuilder searchGroup = app.MapGroup("search");
searchGroup.MapBookSearchEndpoints()
    .AddEndpointFilter<ApiKeyFilter>()
    .WithApiVersionSet(versionSet)
    .MapToApiVersion(ApiVersions.V1);

app.Run();