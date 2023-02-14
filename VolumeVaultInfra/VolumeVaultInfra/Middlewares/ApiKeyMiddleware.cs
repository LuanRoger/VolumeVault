using Microsoft.Extensions.Primitives;
using VolumeVaultInfra.Utils;

namespace VolumeVaultInfra.Middlewares;

public class ApiKeyMiddleware
{
    private readonly RequestDelegate _next;

    public ApiKeyMiddleware(RequestDelegate next)
    {
        _next = next;
    }
    
    public async Task InvokeAsync(HttpContext context)
    {
        bool hasApiKey = context.Request.Headers.TryGetValue("X-Api-Key", out StringValues keys);
        
        string? envApiKey = EnvironmentVariables.GetApiKey();
        string? headerApiKey = hasApiKey ? keys.FirstOrDefault() : null;
        if(hasApiKey || string.IsNullOrEmpty(envApiKey))
        {
            context.Response.StatusCode = 401;
            await context.Response.WriteAsync("API Key was not provided.");
            return;
        }
        
        if(!envApiKey.Equals(headerApiKey))
        {
            context.Response.StatusCode = 401;
            await context.Response.WriteAsync("Invalid API Key");
            return;
        }
        
        await _next(context);
    }
}