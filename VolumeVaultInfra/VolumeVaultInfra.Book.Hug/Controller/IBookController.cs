using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Utils;

namespace VolumeVaultInfra.Book.Hug.Controller;

public interface IBookController
{
    public Task<BookReadModel> GetBook(int bookId, string userId);
    public Task<BookUserRelatedReadModel> GetUserOwnedBook(string userId, int page, int limitPerPage, BookSortOptions? sort);
    public Task<GenresReadModel> GetUserBooksGenres(string userId);
    public Task<int> CreateBook(BookWriteModel writeModel, string userId);
    public Task<int> UpdateBook(BookUpdateModel updateModel, int bookId, string userId);
    public Task<int> RemoveBook(int bookId, string userId);
}