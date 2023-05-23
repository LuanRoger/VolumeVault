using Meilisearch;
using VolumeVaultInfra.Book.Search.Models;
using Index = Meilisearch.Index;

namespace VolumeVaultInfra.Book.Search.Repositories;

public class BookSearchRepository : IBookSearchRepository
{
    private MeilisearchClient client { get; }
    private Index bookSearchIndex { get; }
    
    private const string BOOK_INDEX_PRIMARY_KEY = "id";
    
    public BookSearchRepository(MeilisearchClient client)
    {
        this.client = client;
        
        bookSearchIndex = this.client.Index("book");
    }
    
    public async Task EnsureCreatedAndReady()
    {
        await client.CreateIndexAsync("book", BOOK_INDEX_PRIMARY_KEY);
        Settings bookIndexSettings = new()
        {
            FilterableAttributes = new[] { "ownerId" },
            SortableAttributes = new[] { "title", "author", "publicationYear", "readed" },
            SearchableAttributes = new[] { "title", "author", "isbn", "publicationYear", "publisher", "edition",
                "pagesNumber", "genre", "tags" }
        };
        await bookSearchIndex.UpdateSettingsAsync(bookIndexSettings);
    }

    public async Task<BookSearchModel?> GetBookInSearchById(int bookId, string ownerId)
    {
        BookSearchModel bookResult;
        try
        {
            bookResult = await bookSearchIndex.GetDocumentAsync<BookSearchModel>(bookId);
        }
        catch (Exception){ return null; }
        
        return bookResult;
    }

    public async Task MadeBookSearchable(BookSearchModel bookSearchModel)
    {
        await bookSearchIndex
            .AddDocumentsAsync(new List<BookSearchModel> { bookSearchModel },
                primaryKey: BOOK_INDEX_PRIMARY_KEY);
    }
    
    public async Task UpdateSearchBook(int bookId, BookSearchModel updateModel)
    {
        await bookSearchIndex.UpdateDocumentsAsync(new[] { updateModel }, 
            primaryKey: BOOK_INDEX_PRIMARY_KEY);
    }
    
    public async Task<bool> DeleteBookFromSearch(int bookId)
    {
        TaskInfo taskInfo = await bookSearchIndex.DeleteDocumentsAsync(new[] { bookId });
        TaskResource endResources = await client.WaitForTaskAsync(taskInfo.TaskUid);
        
        return endResources.Error is null;
    }

    public async Task<SearchRepositoryResult> SearchBook(string owenerId, string query, int limitPerSection)
    {
        SearchQuery searchQuery = new()
            { 
                Filter = $"ownerId = {owenerId}",
                Limit = limitPerSection
            };
        var result = 
            await bookSearchIndex.SearchAsync<BookSearchModel>(query, searchQuery);
        
        return new()
        {
            hints = result.Hits.ToList(),
            searchElapsedTime = result.ProcessingTimeMs,
            query = query
        };
    }
}