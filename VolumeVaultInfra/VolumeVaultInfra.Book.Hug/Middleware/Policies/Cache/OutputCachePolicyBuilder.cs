namespace VolumeVaultInfra.Book.Hug.Middleware.Policies.Cache;

public static class OutputCachePolicyBuilder
{
    public static IServiceCollection AddOutputCachePolicy(this IServiceCollection services)
    {
        services.AddOutputCache(options =>
        {
            options.AddBasePolicy(policyBuilder =>
            {
                policyBuilder.Expire(TimeSpan.FromSeconds(10));
                policyBuilder.NoCache();
            });
        });
        
        return services;
    }
    
    public static RouteHandlerBuilder CacheBookOutputDiffByUserIdPageBookFormatAndLimit(this RouteHandlerBuilder builder, 
        string userIdParamName, string pageParamName, string bookFormatParamName, string limitParamName)
    {
        builder.CacheOutput(options =>
        {
            options.SetVaryByQuery(userIdParamName, pageParamName, limitParamName, bookFormatParamName);
            options.Tag(CacheTags.CACHE_BOOK_TAG);
        });
        return builder;
    }
    
    public static RouteHandlerBuilder CacheStatsOutputDiffByUserId(this RouteHandlerBuilder builder, 
        string userIdParamName)
    {
        builder.CacheOutput(options =>
        {
            options.SetVaryByQuery(userIdParamName);
            options.Expire(TimeSpan.FromSeconds(3));
            options.Tag(CacheTags.CACHE_STATS_TAG);
        });
        return builder;
    }
    
    public static RouteHandlerBuilder CacheBadgeArchiveOutputDiffByEmail(this RouteHandlerBuilder builder,
        string emailParamName)
    {
        builder.CacheOutput(options =>
        {
            options.SetVaryByQuery(emailParamName);
            options.Tag(CacheTags.CACHE_BADGE_ARCHIVE);
        });
        return builder;
    }
    
    public static RouteHandlerBuilder CacheBadgeOutputDiffByUserId(this RouteHandlerBuilder builder,
        string userIdParamName)
    {
        builder.CacheOutput(options =>
        {
            options.SetVaryByRouteValue(userIdParamName);
            options.Tag(CacheTags.CACHE_BADGE_TAG);
        });
        return builder;
    }
    
    public static RouteHandlerBuilder CacheAuthOutputDiffByEmail(this RouteHandlerBuilder builder,
        string emailParamName)
    {
        builder.CacheOutput(options =>
        {
            options.Expire(TimeSpan.FromSeconds(5));
            options.SetVaryByRouteValue(emailParamName);
            options.Tag(CacheTags.CACHE_AUTH_TAG);
        });
        return builder;
    }
    public static RouteHandlerBuilder CacheAuthOutputDiffById(this RouteHandlerBuilder builder,
        string idParamName)
    {
        builder.CacheOutput(options =>
        {
            options.Expire(TimeSpan.FromSeconds(5));
            options.SetVaryByRouteValue(idParamName);
            options.Tag(CacheTags.CACHE_AUTH_TAG);
        });
        return builder;
    }
}