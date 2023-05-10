using VolumeVaultInfra.Book.Hug.Models;

namespace VolumeVaultInfra.Book.Hug.Controller;

public interface IBookController
{
    public Task<int> CreateBook(BookWriteModel writeModel, string userId);
    public Task<int> UpdateBook(BookUpdateModel updateModel, int bookId, string userId);
    public Task<int> RemoveBook(int bookId, string userId);
}