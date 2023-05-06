using Microsoft.AspNetCore.Mvc;
using VolumeVaultInfra.Book.Controllers;
using VolumeVaultInfra.Book.Exceptions;
using VolumeVaultInfra.Book.Models.Book;
using VolumeVaultInfra.Book.Models.Enums;
using VolumeVaultInfra.Book.Models.Utils;

// ReSharper disable UnusedMethodReturnValue.Global

namespace VolumeVaultInfra.Book.Endpoints;

internal static class BookEndpoints
{
    internal static RouteGroupBuilder MapBookEndpoints(this RouteGroupBuilder groupBuilder)
    {
        groupBuilder.MapGet("{userId}",
            async (HttpContext _,
                [FromRoute] string userId,
                [FromQuery] int page,
                [FromQuery] int? limitPerPage,
                [FromQuery] BookSort? sort,
                [FromQuery] bool? ascending,
                [FromServices] IBookController bookController) =>
            {
                BookSortOptions sortOptions = new()
                {
                    sortOptions = sort,
                    ascending = ascending ?? true
                };
                BookUserRelatedReadModel userBooks = await bookController
                    .GetAllUserReleatedBooks(userId, page, limitPerPage ?? 10, sortOptions);

                return Results.Ok(userBooks);
            });
            groupBuilder.MapGet("{userId}/{id:int}", 
                async (HttpContext _,
                    [FromRoute] string userId,
                    [FromRoute] int id,
                    [FromServices] IBookController controller) =>
                {
                    BookReadModel book;
                    try
                    { 
                        book = await controller.GetBookById(userId, id);
                    }
                    catch (Exception e) when (e is BookNotFoundException)
                    {
                        return Results.BadRequest(e.Message);
                    }
                    catch (Exception e) when (e is NotOwnerBookException)
                    {
                        return Results.Unauthorized();
                    }
                    
                    return Results.Ok(book);
                });
            groupBuilder.MapGet("/genres/{userId}", 
                async (HttpContext _,
                    [FromRoute] string userId,
                    [FromServices] IBookController controller) =>
            {
                IReadOnlyList<string> genresResult;
                try
                {
                    genresResult = await controller.GetBooksGenre(userId);
                }
                catch (Exception e)
                {
                    return Results.BadRequest(e.Message);
                }
                
                return Results.Ok(genresResult);
            });
        groupBuilder.MapPost("{userId}",
            async (HttpContext _,
                [FromRoute] string userId,
                [FromBody] BookWriteModel bookWriteInfo,
                [FromServices] IBookController bookController) =>
            {
                BookReadModel registeredBook;
                try
                {
                    registeredBook = await bookController.RegisterNewBook(userId, bookWriteInfo);
                }
                catch (Exception e) when (e is NotValidBookInformationException)
                {
                    return Results.BadRequest(e.Message);
                }

                return Results.Created("database", registeredBook);
            });
        groupBuilder.MapDelete("{userId}/{id:int}",
            async (HttpContext _,
                [FromRoute] string userId,
                [FromRoute] int id,
                [FromServices] IBookController bookController) =>
            {
                int idDeletedBook;
                try
                {
                    idDeletedBook = await bookController.DeleteBook(userId, id);
                }
                catch (Exception e) when (e is BookNotFoundException)
                {
                    return Results.BadRequest(e.Message);
                }
                catch (NotOwnerBookException)
                {
                    return Results.Unauthorized();
                }

                return Results.Ok(idDeletedBook);
            });
        groupBuilder.MapPut("{userId}/{id:int}",
            async (HttpContext _,
                [FromRoute] string userId,
                [FromRoute] int id,
                [FromServices] IBookController bookController,
                [FromBody] BookUpdateModel bookUpdate) =>
            {
                try
                {
                    await bookController.UpdateBook(userId, id, bookUpdate);
                }
                catch (Exception e) when (e is BookNotFoundException or
                                              NotValidBookInformationException)
                {
                    return Results.BadRequest(e.Message);
                }

                return Results.Ok();
            });
        groupBuilder.MapGet("/search/{userId}",
            async (HttpContext _,
                [FromRoute] string userId,
                [FromQuery] string query,
                [FromQuery] int? limitPerPage,
                [FromServices] IBookController bookController) =>
            {
                IReadOnlyList<BookSearchReadModel> searchResult;
                try
                {
                    searchResult = await bookController
                        .SearchBook(userId, query, limitPerPage ?? 10);
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