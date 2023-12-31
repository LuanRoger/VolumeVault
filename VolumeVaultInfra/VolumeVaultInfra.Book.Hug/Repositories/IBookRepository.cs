using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Utils;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public interface IBookRepository
{
    public Task<BookModel> AddBook(BookModel book);
    public Task<BookModel?> GetBookById(Guid id);
    public Task<IReadOnlyList<BookModel>> GetUserOwnedBooksSplited(UserIdentifier user, int section, int limitPerSection, 
        BookResultLimiter? resultLimiter, BookSortOptions? bookSortOptions);
    
    public BookModel DeleteBook(BookModel book);

    public Task Flush();
}