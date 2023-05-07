namespace VolumeVaultInfra.Book.Endpoints;

internal static class UtilsEndpoints
{
    internal static RouteGroupBuilder MapUtilsEndpoints(this RouteGroupBuilder groupBuilder)
    {
        groupBuilder.MapGet("ping", () => Results.Ok("PONG"));

        return groupBuilder;
    }
}