using FluentValidation;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Enums;
using VolumeVaultInfra.Book.Hug.Validators;
using ValidationResult = FluentValidation.Results.ValidationResult;

namespace VolumeVaultInfra.Hug.Test.ValidationTests;

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
                isbn = "000-00-0000-000-0",
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            //Optional parameters
            new BookWriteModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 1,
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            new BookWriteModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 1,
                publisher = "test",
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            new BookWriteModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 1,
                publisher = "test",
                edition = 1,
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            new BookWriteModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 1,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            new BookWriteModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 1,
                publisher = "test",
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            new BookWriteModel
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
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            new BookWriteModel
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
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            new BookWriteModel
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
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            new BookWriteModel
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
                synopsis = "test",
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            new BookWriteModel
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
                synopsis = "test",
                coverLink = "test",
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            new BookWriteModel
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
                synopsis = "test",
                coverLink = "test",
                buyLink = "test",
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            new BookWriteModel
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
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            new BookWriteModel
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
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            new BookWriteModel
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
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            new BookWriteModel
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
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
    private static IEnumerable<BookWriteModel> GetValidBookWireteModelsInputs()
    {
        return new[]
        {
            //General
            new BookWriteModel
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
                synopsis = "test",
                coverLink = "test",
                buyLink = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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

    private static IEnumerable<BookWriteModel> GetInvalidBookWriteModelInput()
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
                genre = new() { "test" },
                format = 0,
                observation = "",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            new BookWriteModel
            {
                title = "test",
                author = "test",
                isbn = "000-00-0000-000-0",
                publicationYear = 0,
                publisher = new('a', 101),
                edition = 1,
                pagesNumber = 1,
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { new('a', 51) },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            //Synopsis
            new BookWriteModel
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
                synopsis = "",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "",
                synopsis = new('a', 501),
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            //Cover link
            new BookWriteModel
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
                synopsis = "test",
                coverLink = "",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "test",
                synopsis = "test",
                coverLink = new('a', 501),
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            //Buy link
            new BookWriteModel
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
                synopsis = "test",
                coverLink = "test",
                buyLink = "",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "test",
                synopsis = "test",
                coverLink = "test",
                buyLink = new('a', 501),
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "test",
                synopsis = "test",
                coverLink = "test",
                buyLink = new('a', 501),
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            },
            //ReadStatus/ReadStartDay/ReadEndDay
            new BookWriteModel
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
                synopsis = "test",
                coverLink = "test",
                buyLink = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 7),
                readEndDay = new DateTime(2023, 1, 1),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "test",
                synopsis = "test",
                coverLink = "test",
                buyLink = "test",
                readStatus = ReadStatus.NotRead,
                readStartDay = new DateTime(2023, 1, 1),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "test",
                synopsis = "test",
                coverLink = "test",
                buyLink = "test",
                readStatus = ReadStatus.NotRead,
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "test",
                synopsis = "test",
                coverLink = "test",
                buyLink = "test",
                readStatus = ReadStatus.NotRead,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "test" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "", "" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
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
                genre = new() { "test" },
                format = 0,
                observation = "test",
                readStatus = ReadStatus.HasReaded,
                readStartDay = new DateTime(2023, 1, 1),
                readEndDay = new DateTime(2023, 1, 7),
                tags = new() { "", "", "" },
                lastModification = DateTime.Today,
                createdAt = DateTime.Today
            }
        };
    }
    #endregion
}