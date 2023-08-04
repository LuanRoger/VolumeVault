using System.Threading.RateLimiting;
using Microsoft.AspNetCore.RateLimiting;

namespace VolumeVaultInfra.Book.Hug.Middleware.Policies.RateLimiter;

public static class RateLimiterPolicyBuilder
{
    internal const string RATE_LIMITER_POLICY = "Concurrency";
    
    public static IServiceCollection AddRateLimiterPolicy(this IServiceCollection services)
    {
        services.AddRateLimiter(options =>
        {
            options.AddConcurrencyLimiter(RATE_LIMITER_POLICY, limiterOptions =>
            {
                limiterOptions.QueueLimit = 1000;
                limiterOptions.PermitLimit = 100;
                limiterOptions.QueueProcessingOrder = QueueProcessingOrder.NewestFirst;
            });
        });
        
        return services;
    }
}