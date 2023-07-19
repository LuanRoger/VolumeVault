using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Book.Hug.Contexts;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Utils;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public class BookRepository : IBookRepository
{
    private DatabaseContext bookDb { get; }
    private IGenreRepository genreRepository { get; }

    public BookRepository(DatabaseContext bookDb, IGenreRepository genreRepository)
    {
        this.bookDb = bookDb;
        this.genreRepository = genreRepository;
    }
    
    public async Task<BookModel> AddBook(BookModel book)
    {
        book.id = Guid.NewGuid();
        var addedBook = await bookDb.books.AddAsync(book);
        
        return addedBook.Entity;
    }
    
    public async Task<BookModel?> GetBookById(Guid id) => await bookDb.books.FindAsync(id);

    public async Task<IReadOnlyList<BookModel>> GetUserOwnedBooksSplited(UserIdentifier user, int section, int limitPerSection, 
        BookResultLimiter? resultLimiter, BookSortOptions? bookSortOptions)
    {
        var splitedBooks = bookDb.books
            .Where(book => book.owner == user)
            .Skip(limitPerSection * section - limitPerSection)
            .Take(limitPerSection);
        if(bookSortOptions is not null)
            splitedBooks = bookSortOptions.ascending ? 
                splitedBooks.OrderBy(bookSortOptions.GetExpression()) :
                splitedBooks.OrderByDescending(bookSortOptions.GetExpression());
        // ReSharper disable once InvertIf
        if(resultLimiter is not null)
        {
            if(resultLimiter.genres is not null)
            {
                var booksWithGenres = await genreRepository
                    .GetBooksByGenres(resultLimiter.genres, user);
                splitedBooks = splitedBooks.Where(book => booksWithGenres.Contains(book));
            }
            if(resultLimiter.bookFormat is not null)
                splitedBooks = splitedBooks
                    .Where(book => book.format == resultLimiter.bookFormat);
        }

        return await splitedBooks.ToListAsync();
    }

    public BookModel DeleteBook(BookModel book) => bookDb.books.Remove(book).Entity;
    
    public async Task Flush() => await bookDb.SaveChangesAsync();
}