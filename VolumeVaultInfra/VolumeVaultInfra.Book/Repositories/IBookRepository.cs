using VolumeVaultInfra.Book.Models.Book;
using VolumeVaultInfra.Book.Models.Utils;

namespace VolumeVaultInfra.Book.Repositories;

public interface IBookRepository
{
    public Task<BookModel> AddBook(BookModel book);
    
    public Task<BookModel?> GetBookById(int id);
    public Task<IReadOnlyList<string>> GetUserBooksGenres(string userId);
    public Task<IReadOnlyList<BookModel>> GetUserOwnedBooksSplited(string userId, int section, int limitPerSection, BookSortOptions? bookSortOptions);
    
    public BookModel DeleteBook(BookModel book);
    
    public Task Flush();
}