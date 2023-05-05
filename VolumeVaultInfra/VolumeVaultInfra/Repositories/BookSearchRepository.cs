using Meilisearch;
using VolumeVaultInfra.Models.Book;
using Index = Meilisearch.Index;

namespace VolumeVaultInfra.Repositories;

public class BookSearchRepository : IBookSearchRepository
{
    private MeilisearchClient _client { get; }
    private Index bookSearchIndex { get; }
    
    private const string BOOK_INDEX_PRIMARY_KEY = "id";
    
    public BookSearchRepository(MeilisearchClient client)
    {
        _client = client;
        
        bookSearchIndex = _client.Index("book");
    }
    
    public async Task EnsureCreatedAndReady()
    {
        await _client.CreateIndexAsync("book", BOOK_INDEX_PRIMARY_KEY);
        Settings bookIndexSettings = new()
        {
            FilterableAttributes = new[] { "ownerId" },
            SortableAttributes = new[] { "title", "author", "publicationYear", "readed" },
            SearchableAttributes = new[] { "title", "author", "isbn", "publicationYear", "publisher", "edition",
                "pagesNumber", "genre", "tags" }
        };
        await bookSearchIndex.UpdateSettingsAsync(bookIndexSettings);
    }
    
    public async Task MadeBookSearchable(BookSearchModel bookSearchModel)
    {
        await bookSearchIndex
            .AddDocumentsAsync(new List<BookSearchModel> { bookSearchModel },
                primaryKey: BOOK_INDEX_PRIMARY_KEY);
    }
    
    public async Task UpdateSearchBook(int bookId, BookSearchModel bookSearchModel)
    {
        await bookSearchIndex.UpdateDocumentsAsync(new[] { bookSearchModel }, 
            primaryKey: BOOK_INDEX_PRIMARY_KEY);
    }
    
    public async Task<bool> DeleteBookFromSearch(int id)
    {
        TaskInfo taskInfo = await bookSearchIndex.DeleteDocumentsAsync(new[] { id });
        TaskResource endResources = await _client.WaitForTaskAsync(taskInfo.TaskUid);
        
        return endResources.Error is null;
    }

    public async Task<IReadOnlyList<BookSearchModel>> SearchBook(string userId, string query, int limitPerSection)
    {
        SearchQuery searchQuery = new()
            { 
                Filter = $"ownerId = {userId}",
                Limit = limitPerSection
            };
        var result = 
            await bookSearchIndex.SearchAsync<BookSearchModel>(query, searchQuery);
        
        return result.Hits.ToList();
    }
}