using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Utils;

namespace VolumeVaultInfra.Book.Hug.Controller;

public interface IBookController
{
    public Task<BookReadModel> GetBookById(int bookId, string userId);
    public Task<BookUserRelatedReadModel> GetUserOwnedBooks(string userId, int page, int limitPerPage, BookSortOptions? sort);
    public Task<GenresReadModel> GetUserBooksGenres(string userId);
    public Task<Guid> RegisterNewBook(BookWriteModel writeModel, string userId);
    public Task<Guid> UpdateBook(BookUpdateModel updateModel, int bookId, string userId);
    public Task<Guid> RemoveBook(int bookId, string userId);
}