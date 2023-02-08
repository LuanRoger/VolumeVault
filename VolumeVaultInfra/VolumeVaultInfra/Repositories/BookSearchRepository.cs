using MongoDB.Driver;
using VolumeVaultInfra.Models.Book;
// ReSharper disable MemberCanBePrivate.Global

namespace VolumeVaultInfra.Repositories;

public class BookSearchRepository : IBookSearchRepository
{
    private IMongoCollection<BookSearchModel> searchCollection { get; }
    public string databaseName { get; }
    public readonly string collectionName = "search_storage";
    
    public BookSearchRepository(IMongoClient mongoClient, string databaseName)
    {
        this.databaseName = databaseName;
        searchCollection = mongoClient
            .GetDatabase(this.databaseName)
            .GetCollection<BookSearchModel>(collectionName);
        CreateDefaultSearchIndexes();
    }
    
    private void CreateDefaultSearchIndexes()
    {
        var pubYearIndex = Builders<BookSearchModel>.IndexKeys
            .Ascending(book => book.publicationYear);
        CreateIndexOptions pubYearIndexOptions = new() { Name = "pubYear_index", Unique = true };
        var editionIndex = Builders<BookSearchModel>.IndexKeys
            .Ascending(book => book.edition);
        CreateIndexOptions editionIndexOptions = new() { Name = "edition_index", Unique = true };
        var pageNumbIndex = Builders<BookSearchModel>.IndexKeys
            .Descending(book => book.pagesNumber);
        CreateIndexOptions pageNumbIndexOptions = new() { Name = "pageNumb_index", Unique = true };
        var tagsIndex = Builders<BookSearchModel>.IndexKeys
            .Text(book => book.tags);
        CreateIndexOptions tagsIndexOptions = new() { Name = "tags_index", Unique = true };
        
        searchCollection.Indexes.CreateMany(new []
        {
            new CreateIndexModel<BookSearchModel>(pubYearIndex, pubYearIndexOptions),
            new CreateIndexModel<BookSearchModel>(editionIndex, editionIndexOptions),
            new CreateIndexModel<BookSearchModel>(pageNumbIndex, pageNumbIndexOptions),
            new CreateIndexModel<BookSearchModel>(tagsIndex, tagsIndexOptions),
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
    public async Task UpdateSearchBook(int id, BookSearchModel bookSearchModel)
    {
        var bookFilter = Builders<BookSearchModel>.Filter
            .Eq(book => book.id, id);
        
        await searchCollection.ReplaceOneAsync(bookFilter, bookSearchModel);
    }
}