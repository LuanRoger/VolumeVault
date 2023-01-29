using VolumeVaultInfra.Models.Book;

namespace VolumeVaultInfra.Repositories;

public interface IBookRepository
{
    public Task<BookModel> AddBook(BookModel book);
    
    public Task<BookModel?> GetBookById(int id);
    public Task<List<BookModel>> GetUserOwnedBooksSplited(int userId, int section, int limitPerSection);
    
    public void DeleteBook(BookModel book);
    
    public Task Flush();
}