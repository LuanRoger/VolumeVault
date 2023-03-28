using System.Collections.Immutable;
using FluentValidation;
using Moq;
using Serilog;
using VolumeVaultInfra.Controllers;
using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.User;
using VolumeVaultInfra.Repositories;
using VolumeVaultInfra.Services.Metrics;
using VolumeVaultInfra.Test.ControllersTests.UserControllerTest;
using VolumeVaultInfra.Validators;

namespace VolumeVaultInfra.Test.ControllersTests.BookControllerTests;

public class GetBookTests
{
    private Mock<IBookRepository> _bookRepository { get; } = new();
    private Mock<IBookSearchRepository> _bookSearchRepository { get; } = new();
    private Mock<IUserRepository> _userRepository { get; } = new();
    private Mock<IBookControllerMetrics> _bookControllerMetricsMock { get; } = new();
    private Mock<ILogger> _logger { get; } = new();
    private BookController _bookController { get; }

    public GetBookTests()
    {
        IValidator<BookWriteModel> bookValidator = new BookWriteModelValidator();
        IValidator<BookUpdateModel> bookUpdateValidator = new BookUpdateModelValidator();

        _bookController = new(_bookRepository.Object, _bookSearchRepository.Object, _userRepository.Object, _bookControllerMetricsMock.Object,
            bookValidator, bookUpdateValidator, _logger.Object);
    }
    
    [Theory]
    [InlineData(1, 10)]
    [InlineData(1, 20)]
    [InlineData(1, 5)]
    [InlineData(2, 10)]
    [InlineData(2, 20)]
    public async void GetBookFromUserTest(int page, int limitPerPage)
    {
        UserModel user = UserFakeModels.userTestDumy;
        _userRepository.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(user);
        _bookRepository.Setup(ex => 
            ex.GetUserOwnedBooksSplited(user.id, page, limitPerPage))
            .ReturnsAsync(BookFakeGenerators.GenerateDumyBooks(limitPerPage).ToList);
        
        var books = await _bookController
            .GetAllUserReleatedBooks(user.id, page, limitPerPage);
        
        Assert.Equal(limitPerPage, books.Count);
    }
    [Fact]
    public async void GetUserBooksGenres()
    {
        IReadOnlyList<string> genres = BookFakeGenerators.GenerateBooksGenre(3).ToImmutableList();
        const int userId = 1;
        
        _bookRepository.Setup(ex => ex.GetUserBooksGenres(userId))
            .ReturnsAsync(genres);
        
        IReadOnlyList<string> genresResult = await _bookController.GetBooksGenre(userId);
        
        Assert.Equal(genres.Count, genresResult.Count);
        Assert.Equal(genres, genresResult);
    }
    
    [Fact]
    public async void SearchForBookTest()
    {
        BookModel book = BookFakeModels.bookModelTestDumy;
        List<BookSearchModel> searchResult = BookFakeGenerators.GenerateMessDumySearchResult().ToList();
        const int userId = 1;
        const int limitPerPage = 1;
        
        _bookRepository.Setup(ex => ex.GetBookById(It.IsAny<int>()))
            .ReturnsAsync(book);
        _bookSearchRepository.Setup(ex => ex.SearchBook(userId, 
            It.IsAny<string>(), limitPerPage)).ReturnsAsync(searchResult);
        
         var result = await _bookController
             .SearchBook(userId, "anySearch", limitPerPage);
         
         Assert.All(result, searchBook => Assert.Equal(userId, searchBook.ownerId));
    }
    [Theory]
    [InlineData(5, 5)]
    [InlineData(10, 10)]
    [InlineData(15, 10)]
    [InlineData(20, 10)]
    public async void SearchResultLimitTest(int limitPerPage, int resultCount)
    {
        List<BookSearchModel> searchResult = BookFakeGenerators.GenerateDumySearchResult(count: resultCount).ToList();
        const int userId = 1;

        _bookSearchRepository.Setup(ex => 
            ex.SearchBook(It.IsAny<int>(), It.IsAny<string>(), limitPerPage))
            .ReturnsAsync(searchResult);
        
        IReadOnlyList<BookSearchReadModel> bookResult = await _bookController
            .SearchBook(userId, "anySearch", limitPerPage);
        
        Assert.NotEmpty(bookResult);
        Assert.Equal(bookResult.Count, resultCount);
    }
}