using FluentValidation;
using Meilisearch;
using Microsoft.EntityFrameworkCore;
using Serilog;
using VolumeVaultInfra.Book.Hug.Contexts;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Endpoints;
using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Mapper.Profiles;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Repositories;
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
    string? mySqlConnectionString = EnvironmentVariables.GetMySQLConnectionString();
    if(string.IsNullOrEmpty(mySqlConnectionString))
        throw new EnvironmentVariableNotProvidedException(EnvVariablesConsts.MY_SQL_CONNECTION_STRING);
    
    options.UseMySQL(mySqlConnectionString);
});
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

builder.Services.AddScoped<IBookRepository, BookRepository>();
builder.Services.AddScoped<IGenreRepository, GenreRepository>();
builder.Services.AddScoped<ITagRepository, TagRepository>();
builder.Services.AddScoped<IUserIdentifierRepository, UserIdentifierRepository>();
builder.Services.AddScoped<IValidator<BookWriteModel>, BookWriteModelValidator>();
builder.Services.AddAutoMapper(typeof(BookModelProfile));

builder.Services.AddScoped<IBookController, BookController>();

WebApplication app = builder.Build();

using (IServiceScope serviceScope = app.Services.CreateScope())
{
    DatabaseContext dbContext = serviceScope.ServiceProvider
        .GetRequiredService<DatabaseContext>();
    dbContext.Database.EnsureCreated();
}

RouteGroupBuilder bookGroup = app.MapGroup("book");
bookGroup.MapBookEndpoints();

app.Run();