using Asp.Versioning.Builder;
using FirebaseAdmin;
using FluentValidation;
using Google.Apis.Auth.OAuth2;
using Meilisearch;
using Microsoft.EntityFrameworkCore;
using Serilog;
using VolumeVaultInfra.Book.Hug.Contexts;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Endpoints;
using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Filters;
using VolumeVaultInfra.Book.Hug.Mapper.Profiles;
using VolumeVaultInfra.Book.Hug.Middleware.Policies.Cache;
using VolumeVaultInfra.Book.Hug.Middleware.Policies.RateLimiter;
using VolumeVaultInfra.Book.Hug.Middleware.Versioning;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Repositories;
using VolumeVaultInfra.Book.Hug.Repositories.Search;
using VolumeVaultInfra.Book.Hug.Utils;
using VolumeVaultInfra.Book.Hug.Validators;
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

FirebaseApp.Create(new AppOptions()
{
    Credential = GoogleCredential.FromFile("volumevault-firebase-adminsdk.json")
});
builder.Services.AddDbContext<DatabaseContext>(options =>
{
    string? mySqlConnectionString = EnvironmentVariables.PostgresConnectionString();
    if(builder.Environment.IsDevelopment())
    {
        mySqlConnectionString = builder.Configuration
            .GetConnectionString("POSTGRES_CONNECTION_STRING");
    }
    
    if(string.IsNullOrEmpty(mySqlConnectionString))
        throw new EnvironmentVariableNotProvidedException(EnvVariablesConsts.POSTGRES_CONNECTION_STRING);
    
    options.UseNpgsql(mySqlConnectionString);
});
builder.Services.AddSingleton<MeilisearchClient>(provider =>
{
    ILogger searchInitializerLogger = provider.GetRequiredService<ILogger>();
    
    string? meilisearchMasterKey = EnvironmentVariables.GetMeiliseachMasterKey();
    string? meilisearchHost = EnvironmentVariables.GetMeiliSearchHost();
    if (!string.IsNullOrEmpty(meilisearchHost) && !string.IsNullOrEmpty(meilisearchMasterKey))
        return new(meilisearchHost, meilisearchMasterKey);
    
    searchInitializerLogger.Warning("Meilisearch host or master key not provided. " +
                   "The search will not be available");
    return null!;

});
builder.Services.AddScoped<IBookSearchRepository, BookSearchRepository>(provider =>
{
    MeilisearchClient? searchClient = provider.GetService<MeilisearchClient>();
    if (searchClient is not null) return new(searchClient);
    
    logger.Warning("The Meilisearch service is not available." +
                   "The serach repository is null");
    return null!;

});

builder.Services.AddAutoMapper(typeof(BookModelMapperProfile));
builder.Services.AddAutoMapper(typeof(UserRecordUserInfoMapperProfile));
builder.Services.AddAutoMapper(typeof(BadgeModelBadgeReadModelMapperProfile));
builder.Services.AddScoped<IValidator<BookWriteModel>, BookWriteModelValidator>();
builder.Services.AddScoped<IValidator<BookUpdateModel>, BookUpdateModelValidator>();
builder.Services.AddScoped<IValidator<GiveUserBadgeRequest>, UserBadgeWriteModelValidator>();
builder.Services.AddScoped<IValidator<AttachBadgeToEmailRequest>, AttachBadgeToEmailRequestValidator>();
builder.Services.AddScoped<IValidator<ClaimUserBadgesRequest>, ClaimUserBadgeRequestValidator>();

builder.Services.AddScoped<IBookRepository, BookRepository>();
builder.Services.AddScoped<IGenreRepository, GenreRepository>();
builder.Services.AddScoped<ITagRepository, TagRepository>();
builder.Services.AddScoped<IUserIdentifierRepository, UserIdentifierRepository>();
builder.Services.AddScoped<IStatsRepository, StatsRepository>();
builder.Services.AddScoped<IBadgeRepository, BadgeRepository>();
builder.Services.AddScoped<IAuthRepository, AuthRepository>();
builder.Services.AddScoped<IEmailUserIdentifierRepository, EmailUserIdentifierRepository>();
builder.Services.AddScoped<IBadgeArchiveRepository, BadgeArchiveRepository>();
builder.Services.AddScoped<IAuthRepository, AuthRepository>();

builder.Services.AddScoped<IBookController, BookController>();
builder.Services.AddScoped<IStatsController, StatsController>();
builder.Services.AddScoped<IBadgeController, BadgeController>();
builder.Services.AddScoped<IBadgeArchiveController, BadgeArchiveController>();
builder.Services.AddScoped<IAuthController, AuthController>();

if(builder.Environment.IsDevelopment())
{
    builder.Services.AddHttpsRedirection(options =>
    {
        options.RedirectStatusCode = StatusCodes.Status307TemporaryRedirect;
    });
}
if(builder.Environment.IsProduction())
{
    builder.Services.AddHttpsRedirection(options =>
    {
        options.RedirectStatusCode = StatusCodes.Status308PermanentRedirect;
    });
}
builder.Services.AddHsts(options =>
{
    options.Preload = true;
    options.MaxAge = TimeSpan.FromDays(365);
});

builder.Services.AddApiVersioningOptions();
builder.Services.AddOutputCachePolicy();
builder.Services.AddRateLimiterPolicy();

WebApplication app = builder.Build();

app.UseRateLimiter();
app.UseHttpsRedirection();
app.UseHsts();
app.UseOutputCache();
ApiVersionSet versionSet = ApiVersions.CreateVersionSet(app);

using (IServiceScope serviceScope = app.Services.CreateScope())
{
    DatabaseContext dbContext = serviceScope.ServiceProvider
        .GetRequiredService<DatabaseContext>();
    dbContext.Database.Migrate();
    IBookSearchRepository? searchRepository = serviceScope.ServiceProvider
        .GetService<IBookSearchRepository>();
    if(searchRepository is not null)
        await searchRepository.EnsureCreatedAndReady();
}

RouteGroupBuilder bookGroup = app.MapGroup("book")
    .AddEndpointFilter<ApiKeyFilter>()
    .RequireRateLimiting(RateLimiterPolicyBuilder.RATE_LIMITER_POLICY)
    .WithApiVersionSet(versionSet)
    .MapToApiVersion(ApiVersions.V1);
bookGroup.MapBookEndpoints();

RouteGroupBuilder statsGroup = app.MapGroup("stats")
    .AddEndpointFilter<ApiKeyFilter>()
    .RequireRateLimiting(RateLimiterPolicyBuilder.RATE_LIMITER_POLICY)
    .WithApiVersionSet(versionSet)
    .MapToApiVersion(ApiVersions.V1);
statsGroup.MapStatsEndpoints();

RouteGroupBuilder badgeGroup = app.MapGroup("badge")
    .AddEndpointFilter<ApiKeyFilter>()
    .RequireRateLimiting(RateLimiterPolicyBuilder.RATE_LIMITER_POLICY)
    .WithApiVersionSet(versionSet)
    .MapToApiVersion(ApiVersions.V1);
badgeGroup.MapBadgeEndpoints();
RouteGroupBuilder badgeArchiveGroup = badgeGroup.MapGroup("archive");
badgeArchiveGroup.MapBadgeArchiveEndpoints();

RouteGroupBuilder authGroup = app.MapGroup("auth")
    .AddEndpointFilter<ApiKeyFilter>()
    .RequireRateLimiting(RateLimiterPolicyBuilder.RATE_LIMITER_POLICY)
    .WithApiVersionSet(versionSet)
    .MapToApiVersion(ApiVersions.V1);
authGroup.MapAuthEndpoints();

app.Run();