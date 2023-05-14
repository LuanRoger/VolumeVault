using Microsoft.AspNetCore.Mvc;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Models;

namespace VolumeVaultInfra.Book.Hug.Endpoints;

internal static class StatsEndpoint
{
    internal static RouteGroupBuilder MapStatsEndpoints(this RouteGroupBuilder groupBuilder)
    {
        groupBuilder.MapGet("/",
             async (HttpContext _,
                 [FromQuery] string userId,
                 [FromServices] IStatsController statsController) =>
        {
            BooksStatsReadModel booksStatsReadModel = await statsController.GetUserBooksStats(userId);
            
            return Results.Ok(booksStatsReadModel);
        });
        
        return groupBuilder;
    }
}