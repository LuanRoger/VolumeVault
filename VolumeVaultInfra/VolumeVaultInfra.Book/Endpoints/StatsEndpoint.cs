using Microsoft.AspNetCore.Mvc;
using VolumeVaultInfra.Book.Controllers;
using VolumeVaultInfra.Book.Models.Stats;

namespace VolumeVaultInfra.Book.Endpoints;

internal static class StatsEndpoint
{
    internal static RouteGroupBuilder MapStatsEndpoints(this RouteGroupBuilder groupBuilder)
    {
        groupBuilder.MapGet("{userId}",
             async (HttpContext context,
                 [FromRoute] string userId,
                 [FromServices] IStatsController statsController) =>
        {
            BooksStatsReadModel booksStatsReadModel = await statsController.GetUserBooksStats(userId);
            
            return Results.Json(booksStatsReadModel);
        });
        
        return groupBuilder;
    }
}