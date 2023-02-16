using Microsoft.AspNetCore.Mvc;
using VolumeVaultInfra.Controllers;
using VolumeVaultInfra.Exceptions;
using VolumeVaultInfra.Models.Book;

namespace VolumeVaultInfra.Endpoints;

internal static class BookEndpoints
{
    
    
    internal static RouteGroupBuilder MapBookEndpoints(this RouteGroupBuilder groupBuilder)
    {
        groupBuilder.MapGet("/",
            async (HttpContext context,
                [FromQuery] int page,
                [FromQuery] int? limitPerPage,
                [FromServices] IBookController bookController) =>
            {
                int idClaim = int.Parse(context.User.Claims
                    .First(claim => claim.Type == "ID").Value);

                List<BookReadModel> userBooks;
                try
                {
                    userBooks = await bookController.GetAllUserReleatedBooks(idClaim, page, limitPerPage ?? 10);
                }
                catch (UserNotFoundException e)
                {
                    return Results.BadRequest(e.Message);
                }

                return Results.Ok(userBooks);
            });
        groupBuilder.MapGet("/search",
            async (HttpContext context,
                [FromQuery] string query,
                [FromServices] IBookController bookController) =>
            {
                int idClaim = int.Parse(context.User.Claims
                    .First(claim => claim.Type == "ID").Value);

                List<BookReadModel> searchResult;
                try
                {
                    searchResult = await bookController.SearchBookParameters(idClaim, query);
                }
                catch (Exception e)
                {
                    return Results.BadRequest(e.Message);
                }

                return Results.Ok(searchResult);
            });
        groupBuilder.MapPost("/",
            async (HttpContext context,
                [FromBody] BookWriteModel bookWriteInfo,
                [FromServices] IBookController bookController) =>
            {
                int idClaim = int.Parse(context.User.Claims
                    .First(claim => claim.Type == "ID").Value);
                
                BookReadModel registeredBook;
                try
                {
                    registeredBook = await bookController.RegisterNewBook(idClaim, bookWriteInfo);
                }
                catch (Exception e) when (e is UserNotFoundException or NotValidBookInformationException)
                {
                    return Results.BadRequest(e.Message);
                }

                return Results.Ok(registeredBook);
            });
        groupBuilder.MapDelete("/{id:int}",
            async (HttpContext context,
                int id,
                [FromServices] IBookController bookController) =>
            {
                int idClaim = int.Parse(context.User.Claims
                    .First(claim => claim.Type == "ID").Value);
                
                int idDeletedBook;
                try
                {
                    idDeletedBook = await bookController.DeleteBook(idClaim, id);
                }
                catch (Exception e) when (e is UserNotFoundException or BookNotFoundException)
                {
                    return Results.BadRequest(e.Message);
                }
                catch (NotOwnerBookException)
                {
                    return Results.Unauthorized();
                }

                return Results.Ok(idDeletedBook);
            });
        groupBuilder.MapPut("/{id:int}",
            async (HttpContext context,
                int id,
                [FromServices] IBookController bookController,
                [FromBody] BookUpdateModel bookUpdate) =>
            {
                int idClaim = int.Parse(context.User.Claims
                    .First(claim => claim.Type == "ID").Value);

                try
                {
                    await bookController.UpdateBook(idClaim, id, bookUpdate);
                }
                catch (Exception e) when (e is UserNotFoundException or
                                              BookNotFoundException or
                                              NotValidBookInformationException)
                {
                    return Results.BadRequest(e.Message);
                }

                return Results.Ok();
            });
        
        return groupBuilder;
    }
}