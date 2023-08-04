using Asp.Versioning;
using VolumeVaultInfra.Book.Hug.Utils;

namespace VolumeVaultInfra.Book.Hug.Middleware.Versioning;

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