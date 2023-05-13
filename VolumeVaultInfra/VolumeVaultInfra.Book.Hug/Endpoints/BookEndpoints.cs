using Microsoft.AspNetCore.Mvc;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Models;

namespace VolumeVaultInfra.Book.Hug.Endpoints;

public static class BookEndpoints
{
    public static RouteGroupBuilder MapBookEndpoints(this RouteGroupBuilder builder)
    {
        builder.MapPost("/", 
            async ([FromQuery] string userId,
                [FromBody] BookWriteModel bookWriteModel,
                [FromServices] IBookController controller) =>
            {
                int newBookId;
                try
                {
                    newBookId = await controller.CreateBook(bookWriteModel, userId);
                }
                catch(NotValidBookInformationException e)
                {
                    return Results.BadRequest(e.Message);
                }
                catch(UserDoesNotExistsException e)
                {
                    return Results.NotFound(e.Message);
                }
                
                return Results.Created("database/search", newBookId);
            });
        builder.MapPut("/{bookId:int}", 
            async ([FromQuery] string userId,
                [FromRoute] int bookId,
                [FromBody] BookUpdateModel bookUpdateModel,
                [FromServices] IBookController controller) =>
            {
                int updatedBookId;
                try
                {
                    updatedBookId = await controller.UpdateBook(bookUpdateModel, bookId, userId);
                }
                catch(NotValidBookInformationException e)
                {
                    return Results.BadRequest(e.Message);
                }
                catch(UserDoesNotExistsException e)
                {
                    return Results.NotFound(e.Message);
                }
                
                return Results.Ok(updatedBookId);
            });
        builder.MapDelete("/{bookId:int}", 
            async (HttpContext _,
                [FromRoute] int bookId,
                [FromQuery] string userId,
                [FromServices] IBookController controller) =>
            {
                int deletedBookId;
                try
                {
                    deletedBookId = await controller.RemoveBook(bookId, userId);
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