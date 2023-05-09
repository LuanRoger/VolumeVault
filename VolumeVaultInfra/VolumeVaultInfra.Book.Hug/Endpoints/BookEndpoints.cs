using System.Xml.XPath;
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
                
                return Results.Ok(newBookId);
            });
        
        return builder;
    }
}