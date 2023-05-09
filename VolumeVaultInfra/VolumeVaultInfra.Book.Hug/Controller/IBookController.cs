using VolumeVaultInfra.Book.Hug.Models;

namespace VolumeVaultInfra.Book.Hug.Controller;

public interface IBookController
{
    public Task<int> CreateBook(BookWriteModel bookWrite, string userId);
}