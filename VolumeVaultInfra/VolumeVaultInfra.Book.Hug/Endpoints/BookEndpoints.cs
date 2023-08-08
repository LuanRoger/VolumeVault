using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Middleware.Policies.Cache;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Enums;
using VolumeVaultInfra.Book.Hug.Models.Utils;

namespace VolumeVaultInfra.Book.Hug.Endpoints;

public static class BookEndpoints
{
    public static RouteGroupBuilder MapBookEndpoints(this RouteGroupBuilder builder)
    {
        builder.MapGet("/",
            async (HttpContext _,
                [FromQuery] string userId,
                [FromQuery] int page,
                [FromQuery] int? limitPerPage,
                [FromQuery] BookSort? sort,
                [FromQuery] BookFormat? bookFormat,
                [FromQuery] bool? ascending,
                [FromServices] IBookController bookController) =>
            {
                BookSortOptions sortOptions = new()
                {
                    sortOptions = sort,
                    ascending = ascending ?? true
                };
                BookResultLimiter? resultLimiter = bookFormat is null ? null : new()
                {
                    bookFormat = bookFormat
                };
                BookUserRelatedReadModel  userBooks = await bookController.GetUserOwnedBooks(userId, page, 
                    limitPerPage ?? 10, resultLimiter, sortOptions);
                

                return Results.Ok(userBooks);
            })
            .CacheBookOutputDiffByUserIdPageBookFormatAndLimit("userId",
                "page", "bookFormat", "limitPerPage");
        
            builder.MapGet("{bookId:guid}", 
                async (HttpContext _,
                    [FromRoute] Guid bookId,
                    [FromQuery] string userId,
                    [FromServices] IBookController controller) =>
                {
                    BookReadModel book;
                    try
                    { 
                        book = await controller.GetBookById(bookId.ToString(), userId);
                    }
                    catch(BookNotFoundException e)
                    {
                        return Results.BadRequest(e.Message);
                    }
                    catch (NotOwnerBookException)
                    {
                        return Results.Unauthorized();
                    }
                    
                    return Results.Ok(book);
                });
            builder.MapGet("genres", 
                async (
                    [FromQuery] string userId,
                    [FromServices] IBookController controller) =>
            {
                GenresReadModel genresRead;
                try
                {
                    genresRead = await controller.GetUserBooksGenres(userId);
                }
                catch(Exception e)
                {
                    return Results.BadRequest(e.Message);
                }
                
                return Results.Ok(genresRead);
            });
        builder.MapPost("/", 
            async ([FromQuery] string userId,
                [FromBody] BookWriteModel bookWriteModel,
                [FromServices] IBookController controller,
                [FromServices] IOutputCacheStore cacheStore, 
                CancellationToken cancellationToken) =>
            {
                Guid newBookId;
                try
                {
                    newBookId = await controller.RegisterNewBook(bookWriteModel, userId);
                    await cacheStore.EvictByTagAsync(CacheTags.CACHE_BOOK_TAG,
                        cancellationToken);
                }
                catch(InvalidBookInformationException e)
                {
                    return Results.BadRequest(e.Message);
                }
                catch(UserDoesNotExistsException e)
                {
                    return Results.NotFound(e.Message);
                }
                
                return Results.Created("database/search", newBookId);
            });
        builder.MapPut("{bookId:guid}", 
            async ([FromQuery] string userId,
                [FromRoute] Guid bookId,
                [FromBody] BookUpdateModel bookUpdateModel,
                [FromServices] IBookController controller,
                [FromServices] IOutputCacheStore cacheStore,
                CancellationToken cancellationToken) =>
            {
                Guid updatedBookId;
                try
                {
                    updatedBookId = await controller.UpdateBook(bookUpdateModel, bookId.ToString(), userId);
                    await cacheStore.EvictByTagAsync(CacheTags.CACHE_BOOK_TAG,
                        cancellationToken);
                }
                catch(InvalidBookInformationException e)
                {
                    return Results.BadRequest(e.Message);
                }
                catch(UserDoesNotExistsException e)
                {
                    return Results.NotFound(e.Message);
                }
                
                return Results.Ok(updatedBookId);
            });
        builder.MapDelete("{bookId:guid}",
            async (HttpContext _,
                [FromRoute] Guid bookId,
                [FromQuery] string userId,
                [FromServices] IBookController controller, 
                [FromServices] IOutputCacheStore cacheStore,
                CancellationToken cancellationToken) =>
            {
                Guid deletedBookId;
                try
                {
                    deletedBookId = await controller.RemoveBook(bookId.ToString(), userId);
                    await cacheStore.EvictByTagAsync(CacheTags.CACHE_BOOK_TAG,
                        cancellationToken);
                }
                catch(BookNotFoundException e)
                {
                    return Results.NotFound(e.Message);
                }
                catch(NotOwnerBookException e)
                {
                    return Results.BadRequest(e.Message);
                }
                
                return Results.Ok(deletedBookId);
            });
        
        return builder;
    }
}