using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Repositories.Search;

public interface IBookSearchRepository
{
    public Task EnsureCreatedAndReady();
    public Task MadeBookSearchable(BookSearchModel bookSearchModel);
    public Task<bool> DeleteBookFromSearch(int bookId);
    public Task UpdateSearchBook(int bookId, BookSearchModel updateModel);
}