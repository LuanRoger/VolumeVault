using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.Utils;

namespace VolumeVaultInfra.Controllers;

public interface IBookController
{ 
    public Task<BookReadModel> GetBookById(string userId, int bookId);
    public Task<IReadOnlyList<string>> GetBooksGenre(string userId);
    
    public Task<BookReadModel> RegisterNewBook(string userId, BookWriteModel book);

    #region Read
    public Task<BookUserRelatedReadModel> GetAllUserReleatedBooks(string userId, int page, int limitPerPage, BookSortOptions? bookSortOptions);
    public Task<IReadOnlyList<BookSearchReadModel>> SearchBook(string userId, string searchQuery, int limitPerPage);
    #endregion
    
    public Task UpdateBook(string userId, int bookId, BookUpdateModel bookUpdate);
    public Task<int> DeleteBook(string userId, int bookId);
}