 using FluentValidation;
using Moq;
using VolumeVaultInfra.Controllers;
 using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.Enums;
using VolumeVaultInfra.Models.User;
using VolumeVaultInfra.Repositories;
using VolumeVaultInfra.Validators;

namespace VolumeVaultInfra.Test.ControllersTests;

public class BookControllerTest
{
    private Mock<IBookRepository> _bookRepository { get; } = new();
    private Mock<IUserRepository> _userRepository { get; } = new();
    private BookController _bookController { get; }

    public BookControllerTest()
    {
        IValidator<BookWriteModel> bookValidator = new BookWriteModelValidator();
        IValidator<BookUpdateModel> bookUpdateValidator = new BookUpdateModelValidator();
        
        _bookController = new(_bookRepository.Object, _userRepository.Object, null,
            bookValidator, bookUpdateValidator);
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
        readed = true,
        tags = new() { "test" },
        createdAt = DateTime.Today,
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
        readed = false,
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
    public async void RegsiterValidBookTest()
    {
        UserModel user = userModelTestDumy;
        BookWriteModel book = bookWriteModelTestDumy;
        
        _userRepository.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(user);
        
        await _bookController.RegisterNewBook(user.id, book);
    }

    private static IEnumerable<BookModel> GenerateDumyBooks(int count = 10)
    {
        for (int i = 0; i < count; i++)
            yield return new()
            {
                id = count,
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
                owner = new()
                {
                    id = 1,
                    username = "test",
                    email = "test@test.com",
                    password = "test1234"
                }
            };
    }
    [Theory]
    [InlineData(1, 10)]
    [InlineData(1, 20)]
    [InlineData(1, 5)]
    [InlineData(2, 10)]
    [InlineData(2, 20)]
    public async void GetBookFromUserTest(int page, int limitPerPage)
    {
        UserModel user = userModelTestDumy;
        _userRepository.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(user);
        _bookRepository.Setup(ex => 
            ex.GetUserOwnedBooksSplited(user.id, page, limitPerPage))
            .ReturnsAsync(GenerateDumyBooks(limitPerPage).ToList);
        
        var books = await _bookController
            .GetAllUserReleatedBooks(user.id, page, limitPerPage, true);
        
        Assert.Equal(limitPerPage, books.Count);
    }
    
    [Fact]
    public async void UpdateBookTest()
    {
        UserModel user = userModelTestDumy;
        BookModel book = bookModelTestDumy;
        book.owner = user;
        BookUpdateModel bookUpdate = bookUpdateModelTestDumy;
        
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
        Assert.Equal(book.readed, bookUpdate.readed);
        Assert.Equal(book.tags, bookUpdate.tags);
    }
    
    [Fact]
    public async void DeleteBookTest()
    {
        UserModel user = userModelTestDumy;
        BookModel book = bookModelTestDumy;
        book.owner = user;
        
        _userRepository.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(user);
        _bookRepository.Setup(ex => ex.GetBookById(It.IsAny<int>()))
            .ReturnsAsync(book);
        
        await _bookController.DeleteBook(It.IsAny<int>(), It.IsAny<int>());
    }
}