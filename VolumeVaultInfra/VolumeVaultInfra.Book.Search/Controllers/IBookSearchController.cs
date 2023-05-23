using VolumeVaultInfra.Book.Search.Models;

namespace VolumeVaultInfra.Book.Search.Controllers;

public interface IBookSearchController
{
    public Task<SearchResultModel> SearchBook(BookSearchRequest searchRequest);
}