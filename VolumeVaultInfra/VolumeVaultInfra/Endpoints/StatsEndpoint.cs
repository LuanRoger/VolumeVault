using Microsoft.AspNetCore.Mvc;
using VolumeVaultInfra.Controllers;
using VolumeVaultInfra.Models.Stats;

namespace VolumeVaultInfra.Endpoints;

internal static class StatsEndpoint
{
    internal static RouteGroupBuilder MapStatsEndpoints(this RouteGroupBuilder groupBuilder)
    {
        groupBuilder.MapGet("/books", 
             async (HttpContext context,
                 [FromServices] IStatsController statsController) =>
        {
            int idClaim = int.Parse(context.User.Claims
                .First(claim => claim.Type == "ID").Value);
            
            BooksStatsReadModel booksStatsReadModel = await statsController.GetUserBooksStats(idClaim);
            
            return Results.Json(booksStatsReadModel);
        });
        
        return groupBuilder;
    }
}