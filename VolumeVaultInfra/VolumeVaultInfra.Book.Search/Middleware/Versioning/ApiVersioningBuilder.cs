using Asp.Versioning;

namespace VolumeVaultInfra.Book.Search.Middleware.Versioning;

public static class ApiVersioningBuilder
{
    public static IServiceCollection AddApiVersioningOptions(this IServiceCollection services)
    {
        services.AddApiVersioning(options =>
        {
            options.ReportApiVersions = true;
            options.AssumeDefaultVersionWhenUnspecified = true;
            options.DefaultApiVersion = ApiVersions.V1;
            options.ApiVersionReader = new HeaderApiVersionReader(ApiVersioningConsts.API_VERSION_HEADER);
        });

        return services;
    }
}