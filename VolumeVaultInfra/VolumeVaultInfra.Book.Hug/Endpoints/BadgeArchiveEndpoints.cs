using Microsoft.AspNetCore.Mvc;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Exceptions;
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
        });
        builder.MapPost("/",
            async (HttpContext _,
                [FromBody] AttachBadgeToEmailRequest request,
                [FromServices] IBadgeArchiveController controller) =>
            {
                BadgeReadModel attachedBadge;
                try
                {
                    attachedBadge = await controller.AttachBadgeToEmail(request);
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
                [FromServices] IBadgeArchiveController controller) =>
            {
                BadgeReadModel badgeReadModel;
                try
                {
                    badgeReadModel = await controller.ClaimBadgeFromEmailInArchive(request);
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
                [FromServices] IBadgeArchiveController controller) =>
            {
                BadgeReadModel? badgeReadModel;
                try
                {
                    badgeReadModel = await controller.DetachBadgeFromEmail(email, badgeCode);
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