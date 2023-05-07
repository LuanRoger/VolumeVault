using AutoMapper;
using FluentValidation;
using Meilisearch;
using Serilog;
using VolumeVaultInfra.Book.Search;
using VolumeVaultInfra.Book.Search.Exceptions;
using VolumeVaultInfra.Book.Search.MapperResolver;
using VolumeVaultInfra.Book.Search.Models;
using VolumeVaultInfra.Book.Search.Repositories;
using VolumeVaultInfra.Book.Search.Services;
using VolumeVaultInfra.Book.Search.Utils.EnviromentVars;
using VolumeVaultInfra.Book.Search.Validators;
using ILogger = Serilog.ILogger;


WebApplicationBuilder builder = WebApplication.CreateBuilder(args);
builder.Services.AddGrpc();
builder.Services.AddGrpcReflection();

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
builder.Services.AddSingleton<IMapper>(_ =>
{
    MapperConfiguration mapperConfig = new(config =>
    {
        config.CreateMap<Date, DateTime>().ConvertUsing<GrpcDateResolver>();
        config.CreateMap<DateTime, Date>().ConvertUsing<DateTimeGrpcDateResolver>();
        
        config.CreateMap<GrpcBookSearchModel, BookSearchModel>()
            .ConvertUsing<GrpcBookSearchModelBookSearchModelResolver>();
        config.CreateMap<BookSearchModel, GrpcBookSearchModel>();
        config.CreateMap<GrpcBookSearchUpdateModel, BookSearchUpdateModel>()
            .ConvertUsing<GrpcBookSearchUpdateModelBookSearchModelResolver>();
    });
    return mapperConfig.CreateMapper();
});

builder.Services.AddScoped<IBookSearchRepository, BookSearchRepository>();
builder.Services.AddScoped<IValidator<BookSearchModel>, BookSearchModelValidator>();
builder.Services.AddScoped<IValidator<BookSearchUpdateModel>, BookSearchUpdateModelValidator>();

WebApplication app = builder.Build();

using (IServiceScope scope = app.Services.CreateScope())
{
    IBookSearchRepository repository = scope.ServiceProvider
        .GetRequiredService<IBookSearchRepository>();
    await repository.EnsureCreatedAndReady();
}

app.MapGrpcService<BookSearchService>();
app.MapGrpcReflectionService();

app.Run();