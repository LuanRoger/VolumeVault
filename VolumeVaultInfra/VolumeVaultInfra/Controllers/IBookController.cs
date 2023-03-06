using VolumeVaultInfra.Models.Book;

namespace VolumeVaultInfra.Controllers;

public interface IBookController
{ 
    public Task<BookReadModel> GetBookById(int userId, int bookId);
    
    public Task<BookReadModel> RegisterNewBook(int userId, BookWriteModel book);

    #region Read
    public Task<List<BookReadModel>> GetAllUserReleatedBooks(int userId, int page, int limitPerPage);
    public Task<List<BookSearchReadModel>> SearchBook(int userId, string searchQuery, int limitPerPage);
    #endregion
    
    public Task UpdateBook(int userId, int bookId, BookUpdateModel bookUpdate);
    public Task<int> DeleteBook(int userId, int bookId);
}