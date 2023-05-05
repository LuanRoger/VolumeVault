using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Context;
using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.Utils;

namespace VolumeVaultInfra.Repositories;

public class BookRepository : IBookRepository
{
    private DatabaseContext _bookDb { get; }

    public BookRepository(DatabaseContext bookDb)
    {
        _bookDb = bookDb;
    }
    
    public async Task<BookModel> AddBook(BookModel book) => (await _bookDb.books.AddAsync(book)).Entity;
    
    public async Task<BookModel?> GetBookById(int id) => await _bookDb.books.FindAsync(id);
    
    public async Task<IReadOnlyList<string>> GetUserBooksGenres(string userId)
    {
        List<string?> genresFromDb = await _bookDb.books
            .Where(book => book.owner == userId)
            .Select(book => book.genre).ToListAsync();
        var filteredGenres = genresFromDb.OfType<string>()
            .Distinct()
            .OrderDescending()
            .ToList();
        
        return filteredGenres;
    }

    public async Task<IReadOnlyList<BookModel>> GetUserOwnedBooksSplited(string userId, int section, int limitPerSection, 
        BookSortOptions? bookSortOptions)
    {
        var splitedBooks =  _bookDb.books
            .Where(book => book.owner == userId)
            .Skip(limitPerSection * section - limitPerSection)
            .Take(limitPerSection);
        if(bookSortOptions is not null)
            splitedBooks = bookSortOptions.ascending ? 
                splitedBooks.OrderBy(bookSortOptions.GetExpression()) :
                splitedBooks.OrderByDescending(bookSortOptions.GetExpression());
        
        return await splitedBooks.ToListAsync();
    }

    public BookModel DeleteBook(BookModel book) => _bookDb.books.Remove(book).Entity;
    
    public async Task Flush() => await _bookDb.SaveChangesAsync();
}