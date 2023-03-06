using VolumeVaultInfra.Models.Delegates;

namespace VolumeVaultInfra.Endpoints;

internal static class UtilsEndpoints
{
    internal static RouteGroupBuilder MapUtilsEndpoints(this RouteGroupBuilder groupBuilder)
    {
        groupBuilder.MapGet("ping", () => Results.Ok("PONG"));
        groupBuilder.MapGet("check_auth_token", () => Results.Ok())
            .RequireAuthorization(PolicyAuthDelegateTemplates.JWTRequiredIdClaimPolicy);
        
        return groupBuilder;
    }
}