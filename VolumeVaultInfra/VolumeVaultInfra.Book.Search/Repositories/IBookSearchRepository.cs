using VolumeVaultInfra.Book.Search.Models;

namespace VolumeVaultInfra.Book.Search.Repositories;

public interface IBookSearchRepository
{
    public Task EnsureCreatedAndReady();
    public Task MadeBookSearchable(BookSearchModel bookSearchModel);
    public Task<bool> DeleteBookFromSearch(int id);
    public Task UpdateSearchBook(int bookId, BookSearchModel bookSearchModel);
    public Task<IReadOnlyList<BookSearchModel>> SearchBook(string userId, string query, int limitPerSection);
}