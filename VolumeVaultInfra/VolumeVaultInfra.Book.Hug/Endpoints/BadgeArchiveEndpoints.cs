using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Middleware.Policies.Cache;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Endpoints;

public static class BadgeArchiveEndpoints
{
    public static RouteGroupBuilder MapBadgeArchiveEndpoints(this RouteGroupBuilder builder)
    {
        builder.MapGet("/", 
            async (HttpContext _,
                [FromQuery] string email,
                [FromServices] IBadgeArchiveController controller) =>
        {
            BadgeReadModel badgeReadModel;
            try
            {
                badgeReadModel = await controller.GetUserBadgesOnArchive(email);
            }
            catch(Exception e)
            {
                return Results.BadRequest(e.Message);
            }
            
            return Results.Ok(badgeReadModel);
        })
            .CacheBadgeArchiveOutputDiffByEmail("email");
        builder.MapPost("/",
            async (HttpContext _,
                [FromBody] AttachBadgeToEmailRequest request,
                [FromServices] IBadgeArchiveController controller,
                [FromServices] IOutputCacheStore cacheStore, 
                CancellationToken cancellationToken) =>
            {
                BadgeReadModel attachedBadge;
                try
                {
                    attachedBadge = await controller.AttachBadgeToEmail(request);
                    await cacheStore.EvictByTagAsync(CacheTags.CACHE_BADGE_ARCHIVE, 
                        cancellationToken);
                }
                catch(Exception e)
                {
                    return Results.BadRequest(e.Message);
                }
                
                return Results.Ok(attachedBadge);
            });
        builder.MapPut("/", 
            async (HttpContext _,
                [FromBody] ClaimUserBadgesRequest request,
                [FromServices] IBadgeArchiveController controller,
                [FromServices] IOutputCacheStore cacheStore, 
                CancellationToken cancellationToken) =>
            {
                BadgeReadModel badgeReadModel;
                try
                {
                    badgeReadModel = await controller.ClaimBadgeFromEmailInArchive(request);
                    await cacheStore.EvictByTagAsync(CacheTags.CACHE_BADGE_ARCHIVE, 
                        cancellationToken);
                }
                catch(UserEmailDoesNotExitsException e)
                {
                    return Results.NotFound(e.Message);
                }
                catch(Exception e)
                {
                    return Results.BadRequest(e.Message);
                }
                
                return Results.Ok(badgeReadModel);
            });
        builder.MapDelete("/", 
            async (HttpContext _,
                [FromQuery] string email,
                [FromQuery] BadgeCode badgeCode,
                [FromServices] IBadgeArchiveController controller,
                [FromServices] IOutputCacheStore cacheStore, 
                CancellationToken cancellationToken) =>
            {
                BadgeReadModel? badgeReadModel;
                try
                {
                    badgeReadModel = await controller.DetachBadgeFromEmail(email, badgeCode);
                    await cacheStore.EvictByTagAsync(CacheTags.CACHE_BADGE_ARCHIVE, 
                        cancellationToken);
                }
                catch (Exception e)
                {
                    return Results.BadRequest(e.Message);
                }
                
                return badgeReadModel is null ? Results.NotFound() : Results.Ok(badgeReadModel);
            });

        return builder;
    }
}