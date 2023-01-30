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
    
    [Fact]
    public async void RegsiterValidBookTest()
    {
        BookWriteModel book = new()
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
        UserModel testUser = new()
        {
            id = 1,
            username = "test",
            email = "test@test.com",
            password = "test1234"
        };
        
        _userRepository.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(testUser);
        
        await _bookController.RegisterNewBook(testUser.id, book);
    }

    private IEnumerable<BookModel> GenerateDumyBooks(int count = 10)
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
    [Fact]
    public async void GetBookFromUserTest()
    {
        UserModel testUser = new()
        {
            id = 1,
            username = "test",
            email = "test@test.com",
            password = "test1234"
        };
        _userRepository.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(testUser);
        _bookRepository.Setup(ex => 
            ex.GetUserOwnedBooksSplited(testUser.id, 1, 10))
            .ReturnsAsync(GenerateDumyBooks().ToList);
        
        await _bookController.GetAllUserReleatedBooks(testUser.id, 1, 10, true);
    }
    [Fact]
    public async void UpdateBookTest()
    {
        UserModel testUser = new()
        {
            id = 1,
            username = "test",
            email = "test@test.com",
            password = "test1234"
        };
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
            owner = testUser
        };
        BookUpdateModel updatedBook = new()
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
        _userRepository.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(testUser);
        _bookRepository.Setup(ex => ex.GetBookById(1))
            .ReturnsAsync(bookModel);
        
        await _bookController.UpdateBook(testUser.id, bookModel.id, updatedBook);
        
        Assert.Equal(updatedBook.title, bookModel.title);
        Assert.Equal(updatedBook.author, bookModel.author);
        Assert.Equal(updatedBook.isbn, bookModel.isbn);
        Assert.Equal(updatedBook.publicationYear, bookModel.publicationYear);
        Assert.Equal(updatedBook.publisher, bookModel.publisher);
        Assert.Equal(updatedBook.edition, bookModel.edition);
        Assert.Equal(updatedBook.pagesNumber, bookModel.pagesNumber);
        Assert.Equal(updatedBook.genre, bookModel.genre);
        Assert.Equal(updatedBook.format, bookModel.format);
        Assert.Equal(updatedBook.observation, bookModel.observation);
        Assert.Equal(updatedBook.readed, bookModel.readed);
        Assert.Equal(updatedBook.tags, bookModel.tags);
    }
    
    [Fact]
    public async void DeleteBookTest()
    {
        UserModel testUser = new()
        {
            id = 1,
            username = "test",
            email = "test@test.com",
            password = "test1234"
        };
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
            owner = testUser
        };
        _userRepository.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(testUser);
        _bookRepository.Setup(ex => ex.GetBookById(It.IsAny<int>()))
            .ReturnsAsync(bookModel);
        
        await _bookController.DeleteBook(1, 1);
    }
}