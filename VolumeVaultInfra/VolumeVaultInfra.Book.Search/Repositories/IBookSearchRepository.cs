using VolumeVaultInfra.Book.Search.Models;

namespace VolumeVaultInfra.Book.Search.Repositories;

public interface IBookSearchRepository
{
    public Task EnsureCreatedAndReady();
    public Task<BookSearchModel?> GetBookInSearchById(string bookId, string ownerId);
    public Task MadeBookSearchable(BookSearchModel bookSearchModel);
    public Task<bool> DeleteBookFromSearch(string bookId);
    public Task UpdateSearchBook(string bookId, BookSearchModel updateModel);
    public Task<SearchRepositoryResult> SearchBook(string owenerId, string query, int limitPerSection);
}