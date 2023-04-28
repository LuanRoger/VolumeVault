using FluentValidation;
using Moq;
using Serilog;
using VolumeVaultInfra.Controllers;
using VolumeVaultInfra.Exceptions;
using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.Enums;
using VolumeVaultInfra.Models.User;
using VolumeVaultInfra.Models.Utils;
using VolumeVaultInfra.Repositories;
using VolumeVaultInfra.Services.Metrics;
using VolumeVaultInfra.Validators;

namespace VolumeVaultInfra.Test.ControllersTests;

public class BookControllerExceptionsTest
{
    private Mock<IBookRepository> _bookRepositoryMock { get; } = new();
    private Mock<IBookSearchRepository> _bookSearchRepository { get; } = new();
    private Mock<IUserRepository> _userRepositoryMock { get; } = new();
    private Mock<IBookControllerMetrics> _bookControllerMetricsMock { get; } = new();
    private Mock<ILogger> _logger { get; } = new();
    private BookController _bookController { get; }

    public BookControllerExceptionsTest()
    {
        IValidator<BookWriteModel> bookValidator = new BookWriteModelValidator();
        IValidator<BookUpdateModel> bookUpdateValidator = new BookUpdateModelValidator();

        _bookController = new(_bookRepositoryMock.Object, _bookSearchRepository.Object,
            _userRepositoryMock.Object, _bookControllerMetricsMock.Object, bookValidator,
            bookUpdateValidator, _logger.Object);
    }
    
    private static BookModel bookModelTestDumy => new()
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
        synopsis = "test",
        coverLink = "test",
        buyLink = "test",
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
    private static BookWriteModel bookWriteModelTestDumy => new()
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
    private static BookWriteModel invalidBookWriteModelTestDumy => new()
    {
        title = "test",
        author = "test",
        isbn = "000-00-0000-000-", //Not valid ISBN
        publicationYear = 0,
        publisher = "test",
        edition = 1,
        pagesNumber = 1,
        genre = "test",
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
    private static BookUpdateModel bookUpdateModelTestDumy => new()
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
        synopsis = "test",
        coverLink = "test",
        buyLink = "test",
        readStatus = ReadStatus.NotRead,
        tags = new() { "changed", "changed" }
    };
    private static BookUpdateModel invalidBookUpdateModelTestDumy => new()
    {
        title = "changed",
        author = "changed",
        isbn = "999-99-9999-999", //Not valid ISBN
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
        readStatus = ReadStatus.NotRead,
        tags = new() { "changed", "changed" }
    };
    private static UserModel userModelTestDumy => new()
    {
        id = 1,
        username = "test",
        email = "test@test.com",
        password = "test1234"
    };
    
    [Fact]
    public void RegisterInvalidBookTest()
    {
        UserModel user = userModelTestDumy;
        BookWriteModel invalidBook = invalidBookWriteModelTestDumy;
        
        Assert.ThrowsAsync<NotValidBookInformationException>(() => 
            _bookController.RegisterNewBook(user.id, invalidBook));
    }
    [Fact]
    public async void UpdateInvalidBookTest()
    {
        BookUpdateModel invalidBookUpdate = invalidBookUpdateModelTestDumy;
        await Assert.ThrowsAsync<NotValidBookInformationException>(() => 
            _bookController.UpdateBook(It.IsAny<int>(), It.IsAny<int>(), invalidBookUpdate));
    }
    
    [Fact]
    public async void NotRegisteredUserRegisterBookTest()
    {
        BookWriteModel bookWrite = bookWriteModelTestDumy;
        
        _userRepositoryMock.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(() => null);
        
        await Assert.ThrowsAsync<UserNotFoundException>(() => _bookController.RegisterNewBook(It.IsAny<int>(), bookWrite));
    }
    [Fact]
    public async void GetBooksFromNotRegistredUserTest()
    {
        _userRepositoryMock.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(() => null);
        
        await Assert.ThrowsAsync<UserNotFoundException>(() => 
            _bookController.GetAllUserReleatedBooks(It.IsAny<int>(), 1, 10, 
                It.IsAny<BookSortOptions>()));
    }
    [Fact]
    public async void NotRegistredUserDeleteBookTest()
    {
        _userRepositoryMock.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(() => null);
        
        await Assert.ThrowsAsync<UserNotFoundException>(() => _bookController.DeleteBook(1, 1));
    }

    [Fact]
    public async void NotRegistredUserUpdateBookTest()
    {
        const int userId = 5;
        _userRepositoryMock.Setup(ex => ex.GetUserById(userId))
            .ReturnsAsync(() => null);
        
        await Assert.ThrowsAsync<UserNotFoundException>(() => 
            _bookController.UpdateBook(userId, 1, bookUpdateModelTestDumy));
    }
    
    [Fact]
    public async void NotFoundBookToUpdateTest()
    {
        _userRepositoryMock.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(userModelTestDumy);
        _bookRepositoryMock.Setup(ex => ex.GetBookById(It.IsAny<int>()))
            .ReturnsAsync(() => null);
        
        await Assert.ThrowsAsync<BookNotFoundException>(() => 
            _bookController.UpdateBook(It.IsAny<int>(), 1, bookUpdateModelTestDumy));
    }
    
    [Fact]
    public async void BookDontOwnerByUserTest()
    {
        BookModel book = bookModelTestDumy;
        UserModel user = userModelTestDumy;
        book.owner = new() //User is diferent
        {
            id = 2,
            username = "testDiferent",
            email = "test.diferent@test.com",
            password = "test1234"
        };
        BookUpdateModel bookUpdate = bookUpdateModelTestDumy;
        
        _userRepositoryMock.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(user);
        _bookRepositoryMock.Setup(ex => ex.GetBookById(It.IsAny<int>()))
            .ReturnsAsync(book);
        
        await Assert.ThrowsAsync<NotOwnerBookException>(() => 
            _bookController.UpdateBook(It.IsAny<int>(), It.IsAny<int>(), bookUpdate));
    }

    [Fact]
    public async void NotRegistredBookBeingDeletedTest()
    {
        UserModel user = userModelTestDumy;

        _userRepositoryMock.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(user);
        _bookRepositoryMock.Setup(ex => ex.GetBookById(It.IsAny<int>()))
            .ReturnsAsync(() => null);
        
        await Assert.ThrowsAsync<BookNotFoundException>(() => 
            _bookController.DeleteBook(It.IsAny<int>(), 1));
    }
    
    [Fact]
    public async void DeleteNotOwnedUserBookTest()
    {
        BookModel book = bookModelTestDumy;
        UserModel user = userModelTestDumy;
        book.owner = new() //User is diferent
        {
            id = 2,
            username = "testDiferent",
            email = "test.diferent@test.com",
            password = "test1234"
        };
        
        _userRepositoryMock.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(user);
        _bookRepositoryMock.Setup(ex => ex.GetBookById(It.IsAny<int>()))
            .ReturnsAsync(book);
        
        await Assert.ThrowsAsync<NotOwnerBookException>(() => 
            _bookController.DeleteBook(It.IsAny<int>(), It.IsAny<int>()));
    }
}