using Microsoft.Extensions.Primitives;
using VolumeVaultInfra.Book.Hug.Utils;

namespace VolumeVaultInfra.Book.Hug.Filters;

public class ApiKeyFilter : IEndpointFilter
{
    public async ValueTask<object?> InvokeAsync(EndpointFilterInvocationContext context, EndpointFilterDelegate next)
    {
        bool hasApiKey = context.HttpContext.Request.Headers
            .TryGetValue(ApiConsts.API_KEY_REQUEST_HEADER, out StringValues keys);
        
        string? envApiKey = EnvironmentVariables.GetApiKey();
        string? headerApiKey = hasApiKey ? keys.FirstOrDefault() : null;
        if(!hasApiKey || string.IsNullOrEmpty(envApiKey) || !envApiKey.Equals(headerApiKey))
            return Results.Unauthorized();

        return await next(context);
    }
}