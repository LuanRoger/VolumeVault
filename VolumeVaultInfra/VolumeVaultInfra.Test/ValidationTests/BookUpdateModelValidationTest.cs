using FluentValidation;
using FluentValidation.Results;
using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Validators;

namespace VolumeVaultInfra.Test.ValidationTests;

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
            new BookUpdateModel {},
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
                genre = "test"
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
                genre = "test",
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
                genre = "test",
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
              genre = "test",
              format = 0,
              observation = "test",
              readed = false,
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
              genre = "test",
              format = 0,
              observation = "test",
              readed = false,
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
                genre = "",
                format = 0,
                observation = "",
                readed = true,
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
                genre = "test",
                format = 0,
                observation = "test",
                readed = true,
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
                genre = "test",
                format = 0,
                observation = "test",
                readed = true,
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
                genre = "test",
                format = 0,
                observation = "test",
                readed = true,
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
                genre = "test",
                format = 0,
                observation = "test",
                readed = true,
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
                genre = "test",
                format = 0,
                observation = "test",
                readed = true,
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
                genre = "test",
                format = 0,
                observation = "test",
                readed = true,
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
                genre = "test",
                format = 0,
                observation = "test",
                readed = true,
                tags = new() { "test" }
            },
            new BookUpdateModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                edition = 1,
                pagesNumber = 1,
                genre = "test",
                format = 0,
                observation = "test",
                readed = true,
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
                genre = "test",
                format = 0,
                observation = "test",
                readed = true,
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
                genre = "test",
                format = 0,
                observation = "test",
                readed = true,
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
                genre = "",
                format = 0,
                observation = "test",
                readed = true,
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
                genre = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                format = 0,
                observation = "test",
                readed = true,
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
                genre = "test",
                format = 0,
                observation = "",
                readed = true,
                tags = new() { "test" }
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
                genre = "test",
                format = 0,
                observation = "test",
                readed = true,
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
                genre = "test",
                format = 0,
                observation = "test",
                readed = true,
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
                genre = "test",
                format = 0,
                observation = "test",
                readed = true,
                tags = new() { "", "", "" }
            }
        };
    }
    #endregion
}