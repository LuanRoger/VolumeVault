using Microsoft.AspNetCore.Mvc;
using VolumeVaultInfra.Controllers;
using VolumeVaultInfra.Exceptions;
using VolumeVaultInfra.Models.User;

namespace VolumeVaultInfra.Endpoints;

internal static class AuthEndpoints
{
    internal static RouteGroupBuilder MapAuthEndpoints(this RouteGroupBuilder groupBuilder)
    {
        groupBuilder.MapPost("signin",
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

                return Results.Ok(jwt);
            });
        groupBuilder.MapGet("auth/login",
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