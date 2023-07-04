using VolumeVaultInfra.Book.Search.Models;
using VolumeVaultInfra.Book.Search.Models.Enums;

namespace VolumeVaultInfra.Book.Search.Test.BookSearchControllerTest.FakeData;

public static class BookSearchFakeData
{
    public static BookSearchRequest fakeBookSearchRequest => new("test", 10, "0");
    public static SearchRepositoryResult fakeSearchResultModel => new()
    {
        query = "test",
        searchElapsedTime = 1,
        hints = new List<BookSearchModel>
        {
            new()
            {
                id = Guid.NewGuid().ToString(),
                title = "test",
                author = "test",
                isbn = "test",
                publicationYear = 2020,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = BookFormat.EBOOK,
                readStatus = ReadStatus.Reading,
                readStartDay = DateTime.Today,
                readEndDay = DateTime.MaxValue,
                tags = new() { "test" },
                createdAt = DateTime.Now,
                lastModification = DateTime.Now,
                ownerId = "0"
            },
            new()
            {
                id = Guid.NewGuid().ToString(),
                title = "test",
                author = "test",
                isbn = "test",
                publicationYear = 2020,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = BookFormat.EBOOK,
                readStatus = ReadStatus.Reading,
                readStartDay = DateTime.Today,
                readEndDay = DateTime.MaxValue,
                tags = new() { "test" },
                createdAt = DateTime.Now,
                lastModification = DateTime.Now,
                ownerId = "0"
            },
            new()
            {
                id = Guid.NewGuid().ToString(),
                title = "test",
                author = "test",
                isbn = "test",
                publicationYear = 2020,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = BookFormat.EBOOK,
                readStatus = ReadStatus.Reading,
                readStartDay = DateTime.Today,
                readEndDay = DateTime.MaxValue,
                tags = new() { "test" },
                createdAt = DateTime.Now,
                lastModification = DateTime.Now,
                ownerId = "0"
            }
        },
    };
}