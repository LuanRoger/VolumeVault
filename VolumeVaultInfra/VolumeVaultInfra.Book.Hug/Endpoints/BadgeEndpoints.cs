using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Middleware.Policies.Cache;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Endpoints;

public static class BadgeEndpoints
{
    public static RouteGroupBuilder MapBadgeEndpoints(this RouteGroupBuilder builder)
    {
        builder.MapGet("/", 
            async (HttpContext _,
                [FromQuery] string userId,
                [FromServices] IBadgeController controller) =>
        {
            BadgeReadModel badgeReadModel;
            try
            {
                badgeReadModel = await controller.GetUserBadges(userId);
            }
            catch(Exception e)
            {
                return Results.BadRequest(e.Message);
            }
            
            return Results.Ok(badgeReadModel);
        })
            .CacheBadgeOutputDiffByUserId("userId");
        builder.MapPost("/", 
            async (HttpContext _,
                [FromBody] GiveUserBadgeRequest userBadgeWrite,
                [FromServices] IBadgeController controller,
                [FromServices] IOutputCacheStore cacheStore,
                CancellationToken cancellationToken) =>
            {
                try
                {
                    await controller.GiveBadgeToUser(userBadgeWrite);
                    await cacheStore.EvictByTagAsync(CacheTags.CACHE_BADGE_TAG,
                        cancellationToken);
                }
                catch(AllreadyClaimedBadgeException e)
                {
                    return Results.Conflict(e.Message);
                }
                catch(Exception e)
                {
                    return Results.BadRequest(e.Message);
                }
                
                return Results.Created("database/badges", userBadgeWrite.badgeCode);
            });
        builder.MapDelete("{badgeCode}",
            async (HttpContext _, 
                    BadgeCode badgeCode,
                    [FromQuery] string userId,
                    [FromServices] IBadgeController controller,
                    [FromServices] IOutputCacheStore cacheStore,
                    CancellationToken cancellationToken) =>
            {
                BadgeReadModel? removedBadge;
                try
                {
                   removedBadge = await controller.RemoveBadgeFromUser(userId, badgeCode);
                   await cacheStore.EvictByTagAsync(CacheTags.CACHE_BADGE_TAG,
                       cancellationToken);
                }
                catch(Exception e)
                {
                    return Results.BadRequest(e.Message);
                }
                
                return removedBadge is null ? Results.NotFound() : Results.Ok(removedBadge);
            });
        return builder;
    }
}