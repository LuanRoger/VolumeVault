using FluentValidation;
using FluentValidation.Results;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Enums;
using VolumeVaultInfra.Book.Hug.Validators;

namespace VolumeVaultInfra.Hug.Test.ValidationTests;

public class BookUpdateModelValidationTest
{
    [Theory]
    [MemberData(nameof(GetValidBookUpdateModelOptionalParameters))]
    public void ValidateValidBookUpdateModelOptionalParameters(BookUpdateModel bookUpdateModel)
    {
        IValidator<BookUpdateModel> validator = new BookUpdateModelValidator();
        ValidationResult result = validator.Validate(bookUpdateModel);
        Assert.True(result.IsValid);
    }
    
    [Theory]
    [MemberData(nameof(GetInvalidBookUpdateModel))]
    public void ValidateInvalidBookUpdateModel(BookUpdateModel bookUpdateModel)
    {
        IValidator<BookUpdateModel> validator = new BookUpdateModelValidator();
        ValidationResult result = validator.Validate(bookUpdateModel);
        Assert.False(result.IsValid);
    }
    
    #region ValidBookUpdateModelOptionalParametersInput
    public static IEnumerable<object[]> GetValidBookUpdateModelOptionalParameters()
    {
        foreach (BookUpdateModel input in GetValidBookUpdateModelOptionalParametersInput())
            yield return new object[] { input };
    }
    private static IEnumerable<BookUpdateModel> GetValidBookUpdateModelOptionalParametersInput()
    {
        return new[]
        {
            new BookUpdateModel(),
            new BookUpdateModel
            {
                title = "test",
            },
            new BookUpdateModel
            {
                title = "test",
                author = "test"
            },
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 1
            },
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 1,
                publisher = "test"
            },
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 1,
                publisher = "test",
                edition = 0
            },
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 1,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
            },
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 1,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" }
            },
            new BookUpdateModel
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
            },
            new BookUpdateModel
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
                observation = "test"
            },
          new BookUpdateModel
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
              readEndDay = new DateTime(2023, 1, 7)
          },
          new BookUpdateModel
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
              tags = new () { "test" }
          }
        };
    }
    #endregion

    #region InvalidBookUpdateModel
    public static IEnumerable<object[]> GetInvalidBookUpdateModel()
    {
        foreach (BookUpdateModel input in GetInvalidBookUpdateModelInput())
            yield return new object[] { input };
    }
    private static IEnumerable<BookUpdateModel> GetInvalidBookUpdateModelInput()
    {
        return new[]
        {
            //General
            new BookUpdateModel
            {
                title = "",
                author = "",
                isbn = "000-00-0000-000-",
                publicationYear = -1,
                publisher = "",
                edition = 0,
                pagesNumber = 0,
                genre = new() { "" },
                format = 0,
                observation = "",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "" }
            },
            //Title
            new BookUpdateModel
            {
                title = "",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" }
            },
            //Author
            new BookUpdateModel
            {
                title = "test",
                author = "",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" }
            },
            //ISBN
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" }
            },
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "0000000000000",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" }
            },
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" }
            },
            //Publication year
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = -1,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" }
            },
            //Publisher
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" }
            },
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = new string('a', 101),
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" }
            },
            //Edition
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 0,
                pagesNumber = 1,
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" }
            },
            //Page number
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 0,
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" }
            },
            //Genre
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" }
            },
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { new('a', 50) },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" }
            },
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new(),
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" }
            },
            //Observation
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = 0,
                observation = "",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" }
            },
            //ReadStatus/ReadStartDay/ReadEndDay
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 7),
                readEndDay = new DateTime(2023, 1, 1),
                tags = new() { "test" },
                lastModification = DateTime.Today
            },
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.NotRead,
                readStartDay = new DateTime(2023, 1, 1),
                tags = new() { "test" },
                lastModification = DateTime.Today
            },
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.NotRead,
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today
            },
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.NotRead,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
            },
            //Tags
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "" }
            },
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "", "" }
            },
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "", "", "" }
            }
        };
    }
    #endregion
}