using Microsoft.AspNetCore.Mvc;
using VolumeVaultInfra.Book.Hug.Controller;
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
        });
        builder.MapPost("/", 
            async (HttpContext _,
                [FromQuery] string userId,
                [FromQuery] BadgeCodes badgeCode,
                [FromServices] IBadgeController controller) =>
            {
                try
                {
                    await controller.GiveBadgeToUser(userId, badgeCode);
                }
                catch(Exception e)
                {
                    return Results.BadRequest(e.Message);
                }
                
                return Results.Created("database/badges", badgeCode);
            });
        builder.MapDelete("{badgeCode}",
            async (HttpContext _, 
                    BadgeCodes badgeCode,
                    [FromQuery] string userId,
                    [FromServices] IBadgeController controller) =>
            {
                try
                {
                    await controller.RemoveBadgeFromUser(userId, badgeCode);
                }
                catch(Exception e)
                {
                    return Results.BadRequest(e.Message);
                }
                
                return Results.Ok();
            });
        return builder;
    }
}