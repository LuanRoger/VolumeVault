using FluentValidation;
using Meilisearch;
using Microsoft.EntityFrameworkCore;
using Serilog;
using VolumeVaultInfra.Book.Hug.Contexts;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Endpoints;
using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Filters;
using VolumeVaultInfra.Book.Hug.Mapper.Profiles;
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

builder.Services.AddScoped<IBookRepository, BookRepository>();
builder.Services.AddScoped<IGenreRepository, GenreRepository>();
builder.Services.AddScoped<ITagRepository, TagRepository>();
builder.Services.AddScoped<IUserIdentifierRepository, UserIdentifierRepository>();
builder.Services.AddScoped<IValidator<BookWriteModel>, BookWriteModelValidator>();
builder.Services.AddScoped<IValidator<BookUpdateModel>, BookUpdateModelValidator>();
builder.Services.AddAutoMapper(typeof(BookModelMapperProfile));

builder.Services.AddScoped<IBookController, BookController>();

WebApplication app = builder.Build();

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

RouteGroupBuilder bookGroup = app.MapGroup("book");
bookGroup.MapBookEndpoints()
    .AddEndpointFilter<ApiKeyFilter>();

app.Run();