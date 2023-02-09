using MongoDB.Driver;
using VolumeVaultInfra.Models.Book;
// ReSharper disable MemberCanBePrivate.Global

namespace VolumeVaultInfra.Repositories;

public class BookSearchRepository : IBookSearchRepository
{
    private IMongoCollection<BookSearchModel> searchCollection { get; }
    public string databaseName { get; }
    public const string COLLECTION_NAME = "search_storage";

    public BookSearchRepository(IMongoClient mongoClient, string databaseName)
    {
        this.databaseName = databaseName;
        searchCollection = mongoClient
            .GetDatabase(this.databaseName)
            .GetCollection<BookSearchModel>(COLLECTION_NAME);
        CreateDefaultSearchIndexes();
    }
    
    private void CreateDefaultSearchIndexes()
    {
        var textIndex = Builders<BookSearchModel>.IndexKeys
            .Text("$**");
        CreateIndexOptions textIndexOptions = new() { Name = "text_index" };
        var pubYearIndex = Builders<BookSearchModel>.IndexKeys
            .Ascending(book => book.publicationYear);
        CreateIndexOptions pubYearIndexOptions = new() { Name = "pubYear_index" };
        var editionIndex = Builders<BookSearchModel>.IndexKeys
            .Ascending(book => book.edition);
        CreateIndexOptions editionIndexOptions = new() { Name = "edition_index" };
        var pageNumbIndex = Builders<BookSearchModel>.IndexKeys
            .Descending(book => book.pagesNumber);
        CreateIndexOptions pageNumbIndexOptions = new() { Name = "pageNumb_index" };

        searchCollection.Indexes.CreateMany(new []
        {
            new CreateIndexModel<BookSearchModel>(textIndex, textIndexOptions),
            new CreateIndexModel<BookSearchModel>(pubYearIndex, pubYearIndexOptions),
            new CreateIndexModel<BookSearchModel>(editionIndex, editionIndexOptions),
            new CreateIndexModel<BookSearchModel>(pageNumbIndex, pageNumbIndexOptions),
        });
    }
    
    public async Task MadeBookSearchable(BookSearchModel bookSearchModel) => 
        await searchCollection.InsertOneAsync(bookSearchModel);
    public async Task<bool> DeleteBookFromSearch(int id)
    {
        var bookFilter = Builders<BookSearchModel>.Filter
            .Eq(book => book.id, id);

        return (await searchCollection.DeleteOneAsync(bookFilter)).IsAcknowledged;
    }
    public async Task UpdateSearchBook(int bookId, BookSearchModel bookSearchModel)
    {
        var bookFilter = Builders<BookSearchModel>.Filter
            .Eq(book => book.id, bookId);
        
        await searchCollection.ReplaceOneAsync(bookFilter, bookSearchModel);
    }
    
    public async Task<List<BookSearchModel>> SearchBook(int userId, string sentence)
    {
        var bookFilter = Builders<BookSearchModel>.Filter
            .Text(sentence, new TextSearchOptions());
        var searchResult = await searchCollection.FindAsync(bookFilter);
        List<BookSearchModel> bookList = await searchResult.ToListAsync();

        var filteredResult = 
            from book in bookList where book.ownerId == userId select book;
        
        return filteredResult.ToList();
    }
}