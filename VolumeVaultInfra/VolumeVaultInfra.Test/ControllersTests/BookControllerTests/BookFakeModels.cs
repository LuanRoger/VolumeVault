using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.Enums;

namespace VolumeVaultInfra.Test.ControllersTests.BookControllerTests;

internal static class BookFakeModels
{
    public static BookModel bookModelTestDumy => new()
    {
        id = 1,
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
        readed = true,
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
    public static BookWriteModel bookWriteModelTestDumy => new()
    {
        title = "test",
        author = "test",
        isbn = "000-00-0000-000-0",
        publicationYear = 1,
        publisher = "test",
        edition = 1,
        pagesNumber = 1,
        genre = "test",
        format = 0,
        observation = "test",
        readed = true,
        tags = new()
        {
            "test"
        },
        createdAt = DateTime.Today,
        lastModification = DateTime.Today
    };
    public static BookUpdateModel bookUpdateModelTestDumy => new()
    {
        title = "changed",
        author = "changed",
        isbn = "999-99-9999-999-9",
        publicationYear = 1,
        publisher = "changed",
        edition = 2,
        pagesNumber = 2,
        genre = "changed",
        format = BookFormat.HARDBACK,
        observation = "changed",
        synopsis = "changed",
        coverLink = "changed",
        buyLink = "changed",
        readed = false,
        tags = new() { "changed", "changed" },
        lastModification = DateTime.Now
    };
}