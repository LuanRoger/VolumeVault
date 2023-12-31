using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public interface IGenreRepository
{
    public Task RelateBookGenreRange(IEnumerable<GenreModel> genres, BookModel book, UserIdentifier user);
    public Task<GenreModel> RelateBookGenre(GenreModel genres, BookModel book, UserIdentifier user);
    public Task<IReadOnlyList<GenreModel>> GetUserGenres(UserIdentifier user);
    public Task<IReadOnlyList<GenreModel>> GetBookGenres(BookModel book);
    public Task<IReadOnlyList<BookModel>> GetBooksByGenre(string genre, UserIdentifier user);
    public Task<IReadOnlyList<BookModel>> GetBooksByGenres(List<string> genre, UserIdentifier user);
    public Task RemoveAllGenreRalationWithBook(BookModel book);
}