using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Hug.Test.ControllersTests.BookControllerTests.FakeData;

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
        format = 0,
        observation = "test",
        readStatus = ReadStatus.HasReaded,
        readStartDay = new DateTime(2023, 1, 1),
        readEndDay = new DateTime(2023, 1, 7),
        createdAt = DateTime.Today,
        lastModification = DateTime.Today,
        owner = new()
        {
            id = 1,
            userIdentifier = "1"
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
        genre = new() { "test" },
        format = 0,
        observation = "test",
        readStatus = ReadStatus.HasReaded,
        readStartDay = new DateTime(2023, 1, 1),
        readEndDay = new DateTime(2023, 1, 7),
        tags = new() { "test" },
        createdAt = DateTime.Today,
        lastModification = DateTime.Today
    };
    public static BookWriteModel invalidBookWriteModelTestDumy => new()
    {
        title = "test",
        author = "test",
        isbn = "000-00-0000-000-", //Not valid ISBN
        publicationYear = 0,
        publisher = "test",
        edition = 1,
        pagesNumber = 1,
        genre = new() { "test" },
        format = 0,
        observation = "test",
        synopsis = "test",
        coverLink = "test",
        buyLink = "test",
        readStatus = ReadStatus.HasReaded,
        readStartDay = new DateTime(2023, 1, 1),
        readEndDay = new DateTime(2023, 1, 7),
        tags = new() { "test" },
        lastModification = DateTime.Today,
        createdAt = DateTime.Today
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
        genre = new() { "changed", "changed" },
        format = BookFormat.HARDBACK,
        observation = "changed",
        synopsis = "changed",
        coverLink = "changed",
        buyLink = "changed",
        readStatus = ReadStatus.NotRead,
        tags = new() { "changed", "changed" },
        lastModification = DateTime.Now
    };
    public static BookUpdateModel invalidBookUpdateModelTestDumy => new()
    {
        title = "changed",
        author = "changed",
        isbn = "999-99-9999-999", //Not valid ISBN
        publicationYear = 1,
        publisher = "changed",
        edition = 2,
        pagesNumber = 2,
        genre = new() { "changed" },
        format = BookFormat.HARDBACK,
        observation = "changed",
        synopsis = "changed",
        coverLink = "changed",
        buyLink = "changed",
        readStatus = ReadStatus.NotRead,
        tags = new() { "changed", "changed" }
    };
}