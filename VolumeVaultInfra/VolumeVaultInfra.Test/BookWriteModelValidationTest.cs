using FluentValidation;
using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Validators;
using ValidationResult = FluentValidation.Results.ValidationResult;

namespace VolumeVaultInfra.Test;

public class BookWriteModelValidationTest
{
    [Theory]
    [MemberData(nameof(GetBookWriteModelsOptionalParameters))]
    public void ValidateValidBookWriteModelsOptionalParameters(BookWriteModel bookWriteModel)
    {
        IValidator<BookWriteModel> validator = new BookWriteModelValidator();
        ValidationResult result = validator.Validate(bookWriteModel);
        Assert.True(result.IsValid);
    }
    
    [Theory]
    [MemberData(nameof(GetValidBookWireteModels))]
    public void ValidateValidBookWriteModels(BookWriteModel bookWriteModel)
    {
        IValidator<BookWriteModel> validator = new BookWriteModelValidator();
        ValidationResult result = validator.Validate(bookWriteModel);
        Assert.True(result.IsValid);
    }
    
    [Theory]
    [MemberData(nameof(GetInvalidBookWriteModel))]
    public void ValidateInvalidBookWriteModels(BookWriteModel bookWriteModel)
    {
        IValidator<BookWriteModel> validator = new BookWriteModelValidator();
        ValidationResult result = validator.Validate(bookWriteModel);
        Assert.False(result.IsValid);
    }

    #region ValidBookWriteModelsOptionalParametersInputs
    public static IEnumerable<object[]> GetBookWriteModelsOptionalParameters()
    {
        foreach (BookWriteModel input in GetBookWriteModelsOptionalParametersInput())
            yield return new object[] { input };
    }
    private static IEnumerable<BookWriteModel> GetBookWriteModelsOptionalParametersInput()
    {
        return new[]
        {
            //General
            new BookWriteModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0"
            },
            //Optional parameters
            new BookWriteModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0
            },
            new BookWriteModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test"
            },
            new BookWriteModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1
            },
            new BookWriteModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1
            },
            new BookWriteModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = "test"
            },
            new BookWriteModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = "test",
                format = 0
            },
            new BookWriteModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = "test",
                format = 0
            },
            new BookWriteModel
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
                observation = "test"
            },
            new BookWriteModel
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
                readed = true
            },
            new BookWriteModel
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
                tags = new() { "test" }
            }
        };
    }
    #endregion

    #region ValidBookWriteModelsInputs
    public static IEnumerable<object[]> GetValidBookWireteModels()
    {
        foreach (BookWriteModel input in GetValidBookWireteModelsInputs())
            yield return new object[] { input };
    }
    public static IEnumerable<BookWriteModel> GetValidBookWireteModelsInputs()
    {
        return new[]
        {
            //General
            new BookWriteModel
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
                tags = new() { "test" }
            }
        };
    }
    #endregion

    #region InvalidBookWriteModelsInput
    public static IEnumerable<object[]> GetInvalidBookWriteModel()
    {
        foreach (BookWriteModel input in GetInvalidBookWriteModelInput())
            yield return new object[] { input };
    }
    public static IEnumerable<BookWriteModel> GetInvalidBookWriteModelInput()
    {
        return new[]
        {
            //General
            new BookWriteModel
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
            new BookWriteModel
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
            new BookWriteModel
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
            new BookWriteModel
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
            new BookWriteModel
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
            new BookWriteModel
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
            new BookWriteModel
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
            new BookWriteModel
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
            new BookWriteModel
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
            new BookWriteModel
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
            new BookWriteModel
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
            new BookWriteModel
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
            new BookWriteModel
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
            new BookWriteModel
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
            new BookWriteModel
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
            new BookWriteModel
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
            new BookWriteModel
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
            },
        };
    }
    #endregion
}