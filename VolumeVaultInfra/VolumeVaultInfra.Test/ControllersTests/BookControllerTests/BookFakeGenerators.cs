using VolumeVaultInfra.Book.Models.Book;
using VolumeVaultInfra.Book.Models.Enums;

namespace VolumeVaultInfra.Test.ControllersTests.BookControllerTests;

internal static class BookFakeGenerators
{
    public static IEnumerable<BookModel> GenerateDumyBooks(int count = 10)
    {
        for (int i = 0; i < count; i++)
            yield return new()
            {
                id = count,
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = "test",
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                createdAt = DateTime.Today,
                lastModification = DateTime.Today,
                owner = new()
                {
                    id = 1,
                    username = "test",
                    email = "test@test.com",
                    password = "test1234"
                }
            };
    }
    public static IEnumerable<BookSearchModel> GenerateDumySearchResult(int count = 10)
    {
        for (int i = 0; i < count; i++)
            yield return new()
            {
                id = count,
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = "test",
                format = 0,
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                createdAt = DateTime.Today,
                lastModification = DateTime.Today,
                ownerId = 1
            };
    }
    public static IEnumerable<BookSearchModel> GenerateMessDumySearchResult(int count = 10)
    {
        for (int i = 0; i < count; i++)
        {
            Random random = new();
            int randomUserId = random.Next(1, 3);
            yield return new()
            {
                id = count,
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = "test",
                format = 0,
                readStatus = ReadStatus.NotRead,
                tags = new() { "test" },
                createdAt = DateTime.Today,
                lastModification = DateTime.Today,
                ownerId = randomUserId
            };
        }
    }
    
    public static IEnumerable<string> GenerateBooksGenre(int count)
    {
        int genreIndex = 1;
        for(int c = 0; c != count; c++)
            yield return "genre" + genreIndex++;
    }
}