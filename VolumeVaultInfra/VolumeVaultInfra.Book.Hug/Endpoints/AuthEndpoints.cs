using Microsoft.AspNetCore.Mvc;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Models;

namespace VolumeVaultInfra.Book.Hug.Endpoints;

public static class AuthEndpoints
{
    public static RouteGroupBuilder MapAuthEndpoints(this RouteGroupBuilder builder)
    {
        builder.MapGet("email/{email}", 
            async (HttpContext _, 
                [FromRoute] string email,
                [FromServices] IAuthController controller) =>
        {
            UserInfo userInfo;
            try
            {
                userInfo = await controller.GetUserFromAuthWEmail(email);
            }
            catch(UserDoesNotExistsException e)
            {
                return Results.NotFound(e.Message);
            }
            catch(Exception e)
            {
                return Results.BadRequest(e.Message);
            }
            
            return Results.Ok(userInfo);
        });
        builder.MapGet("id/{userId}", 
            async (HttpContext _, 
                [FromRoute] string userId,
                [FromServices] IAuthController controller) =>
            {
                UserInfo userInfo;
                try
                {
                    userInfo = await controller.GetUserFromAuthWIdentifier(userId);
                }
                catch(UserDoesNotExistsException e)
                {
                    return Results.NotFound(e.Message);
                }
                catch(Exception e)
                {
                    return Results.BadRequest(e.Message);
                }
            
                return Results.Ok(userInfo);
            });

        
        return builder;
    }
}