using Asp.Versioning;
using Asp.Versioning.Builder;

namespace VolumeVaultInfra.Book.Hug.Middleware.Versioning;

public static class ApiVersions
{
    public static readonly ApiVersion V1 = new(1, 0);
    
    public static ApiVersionSet CreateVersionSet(WebApplication app) => 
        app.NewApiVersionSet()
            .HasApiVersion(V1)
            .Build();
}