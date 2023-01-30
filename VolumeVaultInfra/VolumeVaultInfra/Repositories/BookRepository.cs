using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Context;
using VolumeVaultInfra.Models.Book;

namespace VolumeVaultInfra.Repositories;

public class BookRepository : IBookRepository
{
    private DatabaseBaseContext _bookDb { get; }

    public BookRepository(DatabaseBaseContext bookDb)
    {
        _bookDb = bookDb;
    }
    
    public async Task<BookModel> AddBook(BookModel book) => (await _bookDb.books.AddAsync(book)).Entity;
    
    public async Task<BookModel?> GetBookById(int id) => await _bookDb.books.FindAsync(id);
    public async Task<List<BookModel>> GetUserOwnedBooksSplited(int userId, int section, int limitPerSection) =>
        await _bookDb.books.Where(book => book.owner.id == userId)
            .Skip(limitPerSection * section - limitPerSection)
            .Take(limitPerSection)
            .ToListAsync();
    
    public void DeleteBook(BookModel book) => _bookDb.books.Remove(book);
    
    public async Task Flush() => await _bookDb.SaveChangesAsync();
}