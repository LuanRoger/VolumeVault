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

public class UpdateBookTests
{
    private Mock<IBookRepository> _bookRepository { get; } = new();
    private Mock<IBookSearchRepository> _bookSearchRepository { get; } = new();
    private Mock<IUserRepository> _userRepository { get; } = new();
    private Mock<IBookControllerMetrics> _bookControllerMetricsMock { get; } = new();
    private Mock<ILogger> _logger { get; } = new();
    private BookController _bookController { get; }

    public UpdateBookTests()
    {
        IValidator<BookWriteModel> bookValidator = new BookWriteModelValidator();
        IValidator<BookUpdateModel> bookUpdateValidator = new BookUpdateModelValidator();

        _bookController = new(_bookRepository.Object, _bookSearchRepository.Object, _userRepository.Object, _bookControllerMetricsMock.Object,
            bookValidator, bookUpdateValidator, _logger.Object);
    }
    
    [Fact]
    public async void UpdateBookTest()
    {
        UserModel user = UserFakeModels.userTestDumy;
        BookModel book = BookFakeModels.bookModelTestDumy;
        book.owner = user;
        BookUpdateModel bookUpdate = BookFakeModels.bookUpdateModelTestDumy;
        
        _userRepository.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(user);
        _bookRepository.Setup(ex => ex.GetBookById(1))
            .ReturnsAsync(book);
        
        await _bookController.UpdateBook(user.id, book.id, bookUpdate);
        
        Assert.Equal(book.title, bookUpdate.title);
        Assert.Equal(book.author, bookUpdate.author);
        Assert.Equal(book.isbn, bookUpdate.isbn);
        Assert.Equal(book.publicationYear, bookUpdate.publicationYear);
        Assert.Equal(book.publisher, bookUpdate.publisher);
        Assert.Equal(book.edition, bookUpdate.edition);
        Assert.Equal(book.pagesNumber, bookUpdate.pagesNumber);
        Assert.Equal(book.genre, bookUpdate.genre);
        Assert.Equal(book.format, bookUpdate.format);
        Assert.Equal(book.observation, bookUpdate.observation);
        Assert.Equal(book.readStatus, bookUpdate.readStatus);
        Assert.Equal(book.tags, bookUpdate.tags);
        Assert.Equal(book.lastModification, bookUpdate.lastModification);
    }
    [Fact]
    public async void UpdateEmptyRequestTest()
    {
        UserModel user = UserFakeModels.userTestDumy;
        BookModel book = BookFakeModels.bookModelTestDumy;
        book.owner = user;
        BookUpdateModel bookUpdate = new()
        {
            lastModification = DateTime.Now
        };
        
        _userRepository.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(user);
        _bookRepository.Setup(ex => ex.GetBookById(1))
            .ReturnsAsync(book);
        
        await _bookController.UpdateBook(user.id, book.id, bookUpdate);
        
        Assert.NotEqual(book.title, bookUpdate.title);
        Assert.NotEqual(book.author, bookUpdate.author);
        Assert.NotEqual(book.isbn, bookUpdate.isbn);
        Assert.NotEqual(book.publicationYear, bookUpdate.publicationYear);
        Assert.NotEqual(book.publisher, bookUpdate.publisher);
        Assert.NotEqual(book.edition, bookUpdate.edition);
        Assert.NotEqual(book.pagesNumber, bookUpdate.pagesNumber);
        Assert.NotEqual(book.genre, bookUpdate.genre);
        Assert.NotEqual(book.format, bookUpdate.format);
        Assert.NotEqual(book.observation, bookUpdate.observation);
        Assert.NotEqual(book.readStatus, bookUpdate.readStatus);
        Assert.NotEqual(book.tags, bookUpdate.tags);
        Assert.NotEqual(book.lastModification, bookUpdate.lastModification);
    }
}