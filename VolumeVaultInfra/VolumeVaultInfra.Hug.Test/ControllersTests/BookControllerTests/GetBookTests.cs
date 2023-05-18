using System.Collections.Immutable;
using AutoMapper;
using FluentValidation;
using Moq;
using Serilog;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Utils;
using VolumeVaultInfra.Book.Hug.Repositories;
using VolumeVaultInfra.Book.Hug.Repositories.Search;
using VolumeVaultInfra.Book.Hug.Validators;
using VolumeVaultInfra.Hug.Test.ControllersTests.BookControllerTests.FakeData;

namespace VolumeVaultInfra.Hug.Test.ControllersTests.BookControllerTests;

public class GetBookTests
{
    private Mock<IBookRepository> bookRepository { get; } = new();
    private Mock<IBookSearchRepository> bookSearchRepository { get; } = new();
    private Mock<IUserIdentifierRepository> userRepository { get; } = new();
    private Mock<IGenreRepository> genreRepository { get; } = new();
    private Mock<ITagRepository> tagRepository { get; } = new();
    //private Mock<IBookControllerMetrics> _bookControllerMetricsMock { get; } = new();
    private Mock<ILogger> logger { get; } = new();
    private Mock<IMapper> mapper { get; } = new();
    private BookController bookController { get; }

    public GetBookTests()
    {
        IValidator<BookWriteModel> bookValidator = new BookWriteModelValidator();
        IValidator<BookUpdateModel> bookUpdateValidator = new BookUpdateModelValidator();

        bookController = new(logger.Object, bookRepository.Object, genreRepository.Object,
            userRepository.Object, tagRepository.Object, bookSearchRepository.Object, mapper.Object,
            bookValidator, bookUpdateValidator);
    }

    [Theory]
    [InlineData(1, 10)]
    [InlineData(1, 20)]
    [InlineData(1, 5)]
    [InlineData(2, 10)]
    [InlineData(2, 20)]
    public async void GetBookFromUserTest(int page, int limitPerPage)
    {
        const string userIdentifier = "1";
        UserIdentifier user = new()
        {
            id = 1,
            userIdentifier = userIdentifier
        };
        BookSortOptions sortOptions = BookUtilsFakeModels.defaultBookSortOptions;
        var dumyBooks = BookFakeGenerators.GenerateDumyBooks(limitPerPage).ToList();
        
        userRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(user);
        bookRepository.Setup(ex => 
            ex.GetUserOwnedBooksSplited(user, page, limitPerPage, It.IsAny<BookSortOptions>()))
            .ReturnsAsync(dumyBooks);
        
        BookUserRelatedReadModel booksResult = await bookController
            .GetUserOwnedBook(user.userIdentifier, page, limitPerPage, sortOptions);
        
        Assert.Equal(page, booksResult.page);
        Assert.Equal(limitPerPage, booksResult.limitPerPage);
    }
    
    [Fact]
    public async void GetUserBooksGenres()
    {
        const string userIdentifier = "1";
        UserIdentifier user = new()
        {
            id = 1,
            userIdentifier = userIdentifier
        };
        var genreModels = BookUtilsFakeModels.bookGenres;
        
        userRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(user);
        genreRepository.Setup(ex => ex.GetUserGenres(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(genreModels);
        
        GenresReadModel genresResult = await bookController.GetUserBooksGenres(userIdentifier);

        Assert.Equal(genreModels.Count, genresResult.count);
        Assert.Equal(genreModels.Select(genre => genre.genre), genresResult.genres);
    }
}