using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.Utils;

namespace VolumeVaultInfra.Repositories;

public interface IBookRepository
{
    public Task<BookModel> AddBook(BookModel book);
    
    public Task<BookModel?> GetBookById(int id);
    public Task<IReadOnlyList<string>> GetUserBooksGenres(int userId);
    public Task<IReadOnlyList<BookModel>> GetUserOwnedBooksSplited(int userId, int section, int limitPerSection, BookSortOptions? bookSortOptions);
    
    public BookModel DeleteBook(BookModel book);
    
    public Task Flush();
}