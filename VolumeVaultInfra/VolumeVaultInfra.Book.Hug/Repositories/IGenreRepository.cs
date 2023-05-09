using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public interface IGenreRepository
{
    public Task AddGenreRange(IEnumerable<GenreModel> genres, BookModel book, UserIdentifier user);
    public Task<IReadOnlyList<GenreModel>> GetUserGenres(UserIdentifier user);
    public Task<IReadOnlyList<GenreModel>> GetBookGenres(BookModel book);
    public Task DeleteAllGenreFromBook(BookModel book);
}