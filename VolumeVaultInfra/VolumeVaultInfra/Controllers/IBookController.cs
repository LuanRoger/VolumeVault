using VolumeVaultInfra.Models.Book;

namespace VolumeVaultInfra.Controllers;

public interface IBookController
{
    public Task<BookReadModel> RegisterNewBook(int userId, BookWriteModel book);

    #region Read
    public Task<List<BookReadModel>> GetAllUserReleatedBooks(int userId, int page, int limitPerPage);
    public Task<List<BookReadModel>> SearchBookParameters(int userId, string searchQuery);
    #endregion
    
    public Task UpdateBook(int userId, int bookId, BookUpdateModel bookUpdate);
    public Task<int> DeleteBook(int userId, int bookId);
}