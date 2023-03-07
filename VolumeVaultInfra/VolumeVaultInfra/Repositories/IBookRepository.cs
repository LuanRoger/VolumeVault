using VolumeVaultInfra.Models.Book;

namespace VolumeVaultInfra.Repositories;

public interface IBookRepository
{
    public Task<BookModel> AddBook(BookModel book);
    
    public Task<BookModel?> GetBookById(int id);
    public Task<IReadOnlyList<string>> GetUserBooksGenres(int userId);
    public Task<IReadOnlyList<BookModel>> GetUserOwnedBooksSplited(int userId, int section, int limitPerSection);
    
    public BookModel DeleteBook(BookModel book);
    
    public Task Flush();
}