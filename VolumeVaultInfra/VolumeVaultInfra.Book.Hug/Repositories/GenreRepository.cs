using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Book.Hug.Contexts;
using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public class GenreRepository : IGenreRepository
{
    private DatabaseContext genreDb { get; }

    public GenreRepository(DatabaseContext genreDb)
    {
        this.genreDb = genreDb;
    }
    
    public async Task RelateBookGenreRange(IEnumerable<GenreModel> genres, BookModel book, UserIdentifier user)
    {
        foreach (GenreModel genre in genres)
            await RelateBookGenre(genre, book, user);
    }
    public async Task<GenreModel> RelateBookGenre(GenreModel genre, BookModel book, UserIdentifier user)
    {
        GenreModel? newGenre = await genreDb.genres.FirstOrDefaultAsync(dbGenre => dbGenre.genre == genre.genre);
        newGenre ??= (await genreDb.genres.AddAsync(genre)).Entity;
            
        BookGenreModel relation = new()
        {
            book = book,
            genre = newGenre,
            userIdentifier = user
        };
         await genreDb.bookGenre.AddAsync(relation);
        
        return newGenre;
    }
    public async Task<IReadOnlyList<GenreModel>> GetUserGenres(UserIdentifier user) =>
        await genreDb.bookGenre
            .Where(genre => genre.userIdentifier.userIdentifier == user.userIdentifier)
            .Select(genre => genre.genre)
            .Distinct()
            .OrderBy(genre => genre.genre)
            .ToListAsync();

    public async Task<IReadOnlyList<GenreModel>> GetBookGenres(BookModel book) =>
        await genreDb.bookGenre
            .Where(genre => genre.book == book)
            .Select(genre => genre.genre)
            .Distinct()
            .OrderBy(genre => genre.genre)
            .ToListAsync();

    public async Task RemoveAllGenreRalationWithBook(BookModel book)
    {
        var relationsToRemove = await genreDb.bookGenre
            .Where(relation => relation.book == book)
            .ToListAsync();
        
        genreDb.bookGenre.RemoveRange(relationsToRemove);
    }
}