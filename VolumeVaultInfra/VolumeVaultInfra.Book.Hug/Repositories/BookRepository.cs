using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Book.Hug.Contexts;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Utils;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public class BookRepository : IBookRepository
{
    private DatabaseContext bookDb { get; }

    public BookRepository(DatabaseContext bookDb)
    {
        this.bookDb = bookDb;
    }
    
    public async Task<BookModel> AddBook(BookModel book) => (await bookDb.books.AddAsync(book)).Entity;
    
    public async Task<BookModel?> GetBookById(int id) => await bookDb.books.FindAsync(id);

    public async Task<IReadOnlyList<BookModel>> GetUserOwnedBooksSplited(UserIdentifier user, int section, int limitPerSection, 
        BookSortOptions? bookSortOptions)
    {
        var splitedBooks = bookDb.books
            .Where(book => book.owner == user)
            .Skip(limitPerSection * section - limitPerSection)
            .Take(limitPerSection);
        if(bookSortOptions is not null)
            splitedBooks = bookSortOptions.ascending ? 
                splitedBooks.OrderBy(bookSortOptions.GetExpression()) :
                splitedBooks.OrderByDescending(bookSortOptions.GetExpression());
        
        return await splitedBooks.ToListAsync();
    }

    public BookModel DeleteBook(BookModel book) => bookDb.books.Remove(book).Entity;
    
    public async Task Flush() => await bookDb.SaveChangesAsync();
}