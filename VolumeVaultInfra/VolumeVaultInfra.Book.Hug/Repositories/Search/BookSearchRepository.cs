using Meilisearch;
using VolumeVaultInfra.Book.Hug.Models.Base;
using Index = Meilisearch.Index;

namespace VolumeVaultInfra.Book.Hug.Repositories.Search;

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

    public async Task MadeBookSearchable(BookSearchModel bookSearchModel)
    {
        await bookSearchIndex
            .AddDocumentsAsync(new List<BookSearchModel> { bookSearchModel },
                primaryKey: BOOK_INDEX_PRIMARY_KEY);
    }
    
    public async Task UpdateSearchBook(BookSearchModel updateModel)
    {
        await bookSearchIndex.UpdateDocumentsAsync(new[] { updateModel }, 
            primaryKey: BOOK_INDEX_PRIMARY_KEY);
    }
    
    public async Task<bool> DeleteBookFromSearch(string bookId)
    {
        TaskInfo taskInfo = await bookSearchIndex.DeleteDocumentsAsync(new [] { bookId });
        TaskResource endResources = await client.WaitForTaskAsync(taskInfo.TaskUid);
        
        return endResources.Error is null;
    }
}