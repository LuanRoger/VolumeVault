using VolumeVaultInfra.Book.Search.Models;

namespace VolumeVaultInfra.Book.Search.Repositories;

public interface IBookSearchRepository
{
    public Task EnsureCreatedAndReady();
    public Task<BookSearchModel?> GetBookInSearchById(int bookId, string ownerId);
    public Task MadeBookSearchable(BookSearchModel bookSearchModel);
    public Task<bool> DeleteBookFromSearch(int bookId);
    public Task UpdateSearchBook(int bookId, BookSearchModel updateModel);
    public Task<IReadOnlyList<BookSearchModel>> SearchBook(string owenerId, string query, int limitPerSection);
}