using FluentValidation;
using Moq;
using VolumeVaultInfra.Controllers;
using VolumeVaultInfra.Exceptions;
using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.Enums;
using VolumeVaultInfra.Models.User;
using VolumeVaultInfra.Repositories;
using VolumeVaultInfra.Validators;

namespace VolumeVaultInfra.Test.ControllersTests;

public class BookControllerExceptionsTest
{
    private Mock<IBookRepository> _bookRepositoryMock { get; } = new();
    private Mock<IUserRepository> _userRepositoryMock { get; } = new();
    private BookController _bookController { get; }

    public BookControllerExceptionsTest()
    {
        IValidator<BookWriteModel> bookValidator = new BookWriteModelValidator();
        IValidator<BookUpdateModel> bookUpdateValidator = new BookUpdateModelValidator();
        
        _bookController = new(_bookRepositoryMock.Object, _userRepositoryMock.Object, null,
            bookValidator, bookUpdateValidator);
    }
    
    private readonly BookWriteModel _bookWriteModelTestDumy =  new()
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
    };
    private readonly BookWriteModel _invalidBookWriteModelTestDumy = new()
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
        readed = true,
        tags = new() { "test" }
    };
    private readonly BookUpdateModel _bookUpdateModelTestDumy = new()
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
        readed = false,
        tags = new() { "changed", "changed" }
    };
    private readonly BookUpdateModel _invalidBookUpdateModelTestDumy =  new()
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
        readed = false,
        tags = new() { "changed", "changed" }
    };
    private readonly UserModel _userModelTestDumy = new()
    {
        id = 1,
        username = "test",
        email = "test@test.com",
        password = "test1234"
    };
    
    [Fact]
    public void RegisterInvalidBookTest()
    {
        Assert.ThrowsAsync<NotValidBookInformationException>(() => 
            _bookController.RegisterNewBook(_userModelTestDumy.id, _invalidBookWriteModelTestDumy));
    }
    [Fact]
    public void UpdateInvalidBookTest()
    {
        Assert.ThrowsAsync<NotValidBookInformationException>(() => 
            _bookController.UpdateBook(1, 1, _invalidBookUpdateModelTestDumy));
    }
    
    [Fact]
    public void NotRegisteredUserRegisterBookTest()
    {
        const int userId = 5;
        _userRepositoryMock.Setup(ex => ex.GetUserById(userId))
            .ReturnsAsync(() => null);
        
        Assert.ThrowsAsync<UserNotFoundException>(() => _bookController.RegisterNewBook(userId, _bookWriteModelTestDumy));
    }
    [Fact]
    public void GetBooksFromNotRegistredUserTest()
    {
        const int userId = 5;
        _userRepositoryMock.Setup(ex => ex.GetUserById(userId))
            .ReturnsAsync(() => null);
        
        Assert.ThrowsAsync<UserNotFoundException>(() => 
            _bookController.GetAllUserReleatedBooks(userId, 1, 10, false));
    }
    [Fact]
    public void NotRegistredUserDeleteBookTest()
    {
        _userRepositoryMock.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(() => null);
        
        Assert.ThrowsAsync<UserNotFoundException>(() => _bookController.DeleteBook(1, 1));
    }

    [Fact]
    public void NotRegistredUserUpdateBookTest()
    {
        
        const int userId = 5;
        _userRepositoryMock.Setup(ex => ex.GetUserById(userId))
            .ReturnsAsync(() => null);
        
        Assert.ThrowsAsync<UserNotFoundException>(() => 
            _bookController.UpdateBook(userId, 1, _bookUpdateModelTestDumy));
    }
    
    [Fact]
    public void NotFoundBookToUpdateTest()
    {
        _userRepositoryMock.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(_userModelTestDumy);
        _bookRepositoryMock.Setup(ex => ex.GetBookById(It.IsAny<int>()))
            .ReturnsAsync(() => null);
        
        Assert.ThrowsAsync<BookNotFoundException>(() => 
            _bookController.UpdateBook(It.IsAny<int>(), 1, _bookUpdateModelTestDumy));
    }
    
    [Fact]
    public void BookDontOwnerByUserTest()
    {
        BookModel bookModel = new()
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
            owner = new() //User is diferent
            {
                id = 2,
                username = "testDiferent",
                email = "test.diferent@test.com",
                password = "test1234"
            }
        };
        _userRepositoryMock.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(_userModelTestDumy);
        _bookRepositoryMock.Setup(ex => ex.GetBookById(1))
            .ReturnsAsync(bookModel);
        
        Assert.ThrowsAsync<NotOwnerBookException>(() => 
            _bookController.UpdateBook(1, 1, It.IsAny<BookUpdateModel>()));
    }

    [Fact]
    public void NotRegistredBookBeingDeletedTest()
    {
        const int userId = 1;
        UserModel testUser = new()
        {
            id = userId,
            username = "test",
            email = "test@test.com",
            password = "test1234"
        };
        _userRepositoryMock.Setup(ex => ex.GetUserById(userId))
            .ReturnsAsync(testUser);
        _bookRepositoryMock.Setup(ex => ex.GetBookById(It.IsAny<int>()))
            .ReturnsAsync(() => null);
        
        Assert.ThrowsAsync<BookNotFoundException>(() => _bookController.DeleteBook(userId, 1));
    }
    
    [Fact]
    public void DeleteNotOwnedUserBookTest()
    {
        BookModel bookModel = new()
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
            owner = new() //User is diferent
            {
                id = 2,
                username = "testDiferent",
                email = "test.diferent@test.com",
                password = "test1234"
            }
        };
        _userRepositoryMock.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(_userModelTestDumy);
        _bookRepositoryMock.Setup(ex => ex.GetBookById(It.IsAny<int>()))
            .ReturnsAsync(bookModel);
        
        Assert.ThrowsAsync<NotOwnerBookException>(() => 
            _bookController.DeleteBook(It.IsAny<int>(), It.IsAny<int>()));
    }
}