using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Utils;

namespace VolumeVaultInfra.Book.Hug.Controller;

public interface IBookController
{
    public Task<BookReadModel> GetBookById(string bookId, string userId);
    public Task<BookUserRelatedReadModel> GetUserOwnedBooks(string userId, int page, int limitPerPage, BookSortOptions? sort);
    public Task<GenresReadModel> GetUserBooksGenres(string userId);
    public Task<Guid> RegisterNewBook(BookWriteModel writeModel, string userId);
    public Task<Guid> UpdateBook(BookUpdateModel updateModel, string bookId, string userId);
    public Task<Guid> RemoveBook(string bookId, string userId);
}