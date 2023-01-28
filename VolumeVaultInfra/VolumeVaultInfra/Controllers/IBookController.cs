using VolumeVaultInfra.Models.Book;

namespace VolumeVaultInfra.Controllers;

public interface IBookController
{
    public Task RegisterNewBook(int userId, BookWriteModel book);

    #region Read
    public Task<List<BookReadModel>> GetAllUserReleatedBooks(int userId, int page, int limitPerPage, 
        bool refresh);
    public List<BookReadModel> SearchBookParameters(BookSearchModel bookSearchParameters);
    #endregion
    
    public Task UpdateBook(int userId, int bookId, BookUpdateModel bookUpdate);
    public Task DeleteBook(int userId, int bookId);
}