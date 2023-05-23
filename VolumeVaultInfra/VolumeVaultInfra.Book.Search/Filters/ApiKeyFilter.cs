using Microsoft.Extensions.Primitives;
using VolumeVaultInfra.Book.Search.Utils;
using VolumeVaultInfra.Book.Search.Utils.EnviromentVars;

namespace VolumeVaultInfra.Book.Search.Filters;

public class ApiKeyFilter : IEndpointFilter
{
    public async ValueTask<object?> InvokeAsync(EndpointFilterInvocationContext context, EndpointFilterDelegate next)
    {
        bool hasApiKey = context.HttpContext.Request.Headers
            .TryGetValue(ApiVariablesConsts.API_KEY_HEADER, out StringValues keys);
        
        string? envApiKey = EnvironmentVariables.GetApiKey();
        string? headerApiKey = hasApiKey ? keys.FirstOrDefault() : null;
        if(!hasApiKey || string.IsNullOrEmpty(envApiKey) || !envApiKey.Equals(headerApiKey))
            return Results.Unauthorized();

        return await next(context);
    }
}