using System.Text.Json;
using Microsoft.Extensions.Caching.Distributed;
using VolumeVaultInfra.Models.Book;

namespace VolumeVaultInfra.Services.Cache;

public class BookCacheService
{
    private IDistributedCache _cache { get; }
    private DistributedCacheEntryOptions _cacheOptions { get; }

    public BookCacheService(IDistributedCache cache, DistributedCacheEntryOptions cacheOptions)
    {
        _cache = cache;
        _cacheOptions = cacheOptions;
    }
    
    public async Task<List<BookReadModel>?> TryGetUserCachedBook(int userId, int page)
    {
        string? booksFromCache = await _cache.GetStringAsync(
            string.Format(CacheStringKeys.USER_BOOK_PAGE, userId, page));
        if(booksFromCache is null) return null;
        
        var userBooks = JsonSerializer
            .Deserialize<List<BookReadModel>>(booksFromCache);
        return userBooks;
    }
    
    public async Task SetUserBooks(List<BookReadModel> userBooks, int userId, int page)
    {
        string serializerBooks = JsonSerializer.Serialize(userBooks);
        string cacheKey = string.Format(CacheStringKeys.USER_BOOK_PAGE, userId, page);

        await _cache.SetStringAsync(cacheKey, serializerBooks);
    }
}