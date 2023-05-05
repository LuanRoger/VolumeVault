using Microsoft.AspNetCore.Mvc;
using VolumeVaultInfra.Controllers;
using VolumeVaultInfra.Exceptions;
using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.Enums;
using VolumeVaultInfra.Models.Utils;

// ReSharper disable UnusedMethodReturnValue.Global

namespace VolumeVaultInfra.Endpoints;

internal static class BookEndpoints
{
    internal static RouteGroupBuilder MapBookEndpoints(this RouteGroupBuilder groupBuilder)
    {
        groupBuilder.MapGet("/",
            async (HttpContext context,
                [FromQuery] int page,
                [FromQuery] int? limitPerPage,
                [FromQuery] BookSort? sort,
                [FromQuery] bool? ascending,
                [FromServices] IBookController bookController) =>
            {
                int idClaim = int.Parse(context.User.Claims
                    .First(claim => claim.Type == "ID").Value);

                BookUserRelatedReadModel userBooks;
                try
                {
                    BookSortOptions sortOptions = new()
                    {
                        sortOptions = sort,
                        ascending = ascending ?? true
                    };
                    userBooks = await bookController
                        .GetAllUserReleatedBooks(idClaim, page, limitPerPage ?? 10, sortOptions);
                }
                catch (UserNotFoundException e)
                {
                    return Results.BadRequest(e.Message);
                }

                return Results.Ok(userBooks);
            });
            groupBuilder.MapGet("/{id:int}", 
                async (HttpContext context,
                    int id,
                    [FromServices] IBookController controller) =>
                {
                    int idClaim = int.Parse(context.User.Claims
                        .First(claim => claim.Type == "ID").Value);
                    
                    BookReadModel book;
                    try
                    { 
                        book = await controller.GetBookById(idClaim, id);
                    }
                    catch (Exception e) when (e is BookNotFoundException or UserNotFoundException)
                    {
                        return Results.BadRequest(e.Message);
                    }
                    catch (Exception e) when (e is NotOwnerBookException)
                    {
                        return Results.Unauthorized();
                    }
                    
                    return Results.Ok(book);
                });
            groupBuilder.MapGet("/genres", 
                async (HttpContext context,
                    [FromServices] IBookController controller) =>
            {
                int idClaim = int.Parse(context.User.Claims
                    .First(claim => claim.Type == "ID").Value);
                
                IReadOnlyList<string> genresResult;
                try
                {
                    genresResult = await controller.GetBooksGenre(idClaim);
                }
                catch (Exception e)
                {
                    return Results.BadRequest(e.Message);
                }
                
                return Results.Ok(genresResult);
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

                return Results.Created("database", registeredBook);
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
        groupBuilder.MapGet("/search",
            async (HttpContext context,
                [FromQuery] string query,
                [FromQuery] int? limitPerPage,
                [FromServices] IBookController bookController) =>
            {
                int idClaim = int.Parse(context.User.Claims
                    .First(claim => claim.Type == "ID").Value);

                IReadOnlyList<BookSearchReadModel> searchResult;
                try
                {
                    searchResult = await bookController
                        .SearchBook(idClaim, query, limitPerPage ?? 10);
                }
                catch (Exception e)
                {
                    return Results.BadRequest(e.Message);
                }

                return Results.Ok(searchResult);
            });
        
        return groupBuilder;
    }
}