using Microsoft.AspNetCore.Mvc;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Endpoints;

public static class BadgeArchiveEndpoints
{
    public static RouteGroupBuilder MapBadgeArchiveEndpoints(this RouteGroupBuilder builder)
    {
        builder.MapPost("/",
            async (HttpContext _,
                [FromQuery] string email,
                [FromQuery] BadgeCodes badgeCode,
                [FromServices] IBadgeArchiveController controller) =>
            {
                BadgeReadModel attachedBadge;
                try
                {
                    attachedBadge = await controller.AttachBadgeToEmail(email, badgeCode);
                }
                catch(Exception e)
                {
                    return Results.BadRequest(e.Message);
                }
                
                return Results.Ok(attachedBadge);
            });
        builder.MapDelete("/", 
            async (HttpContext _,
                [FromQuery] string email,
                [FromQuery] BadgeCodes badgeCode,
                [FromServices] IBadgeArchiveController controller) =>
            {
                BadgeReadModel? badgeReadModel;
                try
                {
                    badgeReadModel = await controller.DetachBadgeToEmail(email, badgeCode);
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