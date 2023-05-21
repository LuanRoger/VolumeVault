using Microsoft.AspNetCore.Mvc;
using VolumeVaultInfra.Book.Search.Controllers;
using VolumeVaultInfra.Book.Search.Exceptions;
using VolumeVaultInfra.Book.Search.Models;

namespace VolumeVaultInfra.Book.Search.Endpoints;

public static class BookSearchEndpoints
{
    public static RouteGroupBuilder MapBookSearchEndpoints(this RouteGroupBuilder builder)
    {
        builder.MapGet("/", 
            async (HttpContext _,
                [FromQuery] string userId,
                [FromQuery] string query,
                [FromQuery] int limitPerSection, 
                [FromServices] IBookSearchController controller) =>
        {
            SearchResultModel searchResult;
            try
            {
                BookSearchRequest searchRequest = new(query, limitPerSection, userId);
                searchResult = await controller.SearchBook(searchRequest);
            }
            catch(NotValidBookInformationException exception)
            {
                return Results.BadRequest(exception.Message);
            }
            
            return Results.Ok(searchResult);
        });
        
        return builder;
    }
}