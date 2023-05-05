using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.Utils;

namespace VolumeVaultInfra.Controllers;

public interface IBookController
{ 
    public Task<BookReadModel> GetBookById(int userId, int bookId);
    public Task<IReadOnlyList<string>> GetBooksGenre(int userId);
    
    public Task<BookReadModel> RegisterNewBook(int userId, BookWriteModel book);

    #region Read
    public Task<BookUserRelatedReadModel> GetAllUserReleatedBooks(int userId, int page, int limitPerPage, BookSortOptions? bookSortOptions);
    public Task<IReadOnlyList<BookSearchReadModel>> SearchBook(int userId, string searchQuery, int limitPerPage);
    #endregion
    
    public Task UpdateBook(int userId, int bookId, BookUpdateModel bookUpdate);
    public Task<int> DeleteBook(int userId, int bookId);
}