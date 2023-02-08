using VolumeVaultInfra.Models.Book;

namespace VolumeVaultInfra.Repositories;

public interface IBookSearchRepository
{
    public Task MadeBookSearchable(BookSearchModel bookSearchModel);
    public Task<bool> DeleteBookFromSearch(int id);
    public Task UpdateSearchBook(int id, BookSearchModel bookSearchModel);
}