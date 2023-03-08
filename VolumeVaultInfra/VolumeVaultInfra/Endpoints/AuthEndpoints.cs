using Microsoft.AspNetCore.Mvc;
using VolumeVaultInfra.Controllers;
using VolumeVaultInfra.Exceptions;
using VolumeVaultInfra.Models.Delegates;
using VolumeVaultInfra.Models.User;
// ReSharper disable UnusedMethodReturnValue.Global

namespace VolumeVaultInfra.Endpoints;

internal static class AuthEndpoints
{
    internal static RouteGroupBuilder MapAuthEndpoints(this RouteGroupBuilder groupBuilder)
    {
        groupBuilder.MapGet("/", 
             async (HttpContext context,
                [FromServices] IUserController controller) =>
        {
            int userId = int.Parse(context.User.Claims
                .First(claim => claim.Type == "ID").Value);
            
            UserReadModel userInfo;
            try
            { 
                userInfo = await controller.GetUserInfo(userId);
            }
            catch(UserIdIsNotRegisteredException e)
            {
                return Results.NotFound(e.Message);
            }
            
            return Results.Ok(userInfo);
        }).RequireAuthorization(PolicyAuthDelegateTemplates.JWTRequiredIdClaimPolicy);
        groupBuilder.MapPost("/signin",
            async ([FromServices] IUserController userController,
                [FromBody] UserWriteModel userWrite) =>
            {
                string jwt;
                try
                {
                    jwt = await userController.SigninUser(userWrite);
                }
                catch (UserAlreadyExistException e)
                {
                    return Results.Conflict(e.Message);
                }
                catch (NotValidUserWriteException e)
                {
                    return Results.BadRequest(e.Message);
                }

                return Results.Created("signin", jwt);
            });
        groupBuilder.MapPost("/login",
            async ([FromServices] IUserController userController,
                [FromBody] UserLoginRequestModel loginRequest) =>
            {
                string jwt;
                try
                {
                    jwt = await userController.LoginUser(loginRequest);
                }
                catch (UsernameIsNotRegisteredException e)
                {
                    return Results.NotFound(e.Message);
                }
                catch (InvalidUserCredentialsException)
                {
                    return Results.Unauthorized();
                }

                return Results.Ok(jwt);
            });
        
        return groupBuilder;
    }
}