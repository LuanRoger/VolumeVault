 using FluentValidation;
using Moq;
 using Serilog;
 using VolumeVaultInfra.Controllers;
 using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.Enums;
using VolumeVaultInfra.Models.User;
using VolumeVaultInfra.Repositories;
 using VolumeVaultInfra.Services.Metrics;
 using VolumeVaultInfra.Validators;

namespace VolumeVaultInfra.Test.ControllersTests;

public class BookControllerTest
{
    private Mock<IBookRepository> _bookRepository { get; } = new();
    private Mock<IBookSearchRepository> _bookSearchRepository { get; } = new();
    private Mock<IUserRepository> _userRepository { get; } = new();
    private Mock<IBookControllerMetrics> _bookControllerMetricsMock { get; } = new();
    private Mock<ILogger> _logger { get; } = new();
    private BookController _bookController { get; }

    public BookControllerTest()
    {
        IValidator<BookWriteModel> bookValidator = new BookWriteModelValidator();
        IValidator<BookUpdateModel> bookUpdateValidator = new BookUpdateModelValidator();

        _bookController = new(_bookRepository.Object, _bookSearchRepository.Object, _userRepository.Object, _bookControllerMetricsMock.Object,
            bookValidator, bookUpdateValidator, _logger.Object);
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
        readed = true,
        tags = new()
        {
            "test"
        },
        createdAt = DateTime.Today,
        lastModification = DateTime.Today
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
        synopsis = "changed",
        coverLink = "changed",
        buyLink = "changed",
        readed = false,
        tags = new() { "changed", "changed" },
        lastModification = DateTime.Now
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
        _bookRepository.Setup(ex => ex.AddBook(It.IsAny<BookModel>()))
            .ReturnsAsync(bookModelTestDumy);
        
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
                lastModification = DateTime.Today,
                owner = new()
                {
                    id = 1,
                    username = "test",
                    email = "test@test.com",
                    password = "test1234"
                }
            };
    }
    private static IEnumerable<BookSearchModel> GenerateDumySearchResult(int count = 10)
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
                readed = true,
                tags = new() { "test" },
                createdAt = DateTime.Today,
                lastModification = DateTime.Today,
                ownerId = 1
            };
    }
    private static IEnumerable<BookSearchModel> GenerateMessDumySearchResult(int count = 10)
    {
        for (int i = 0; i < count; i++)
        {
            Random random = new();
            int randomUserId = random.Next(1, 3);
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
                readed = true,
                tags = new() { "test" },
                createdAt = DateTime.Today,
                lastModification = DateTime.Today,
                ownerId = randomUserId
            };
        }
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
            .GetAllUserReleatedBooks(user.id, page, limitPerPage);
        
        Assert.Equal(limitPerPage, books.Count);
    }
    
    [Fact]
    public async void SearchForBookTest()
    {
        BookModel book = bookModelTestDumy;
        List<BookSearchModel> searchResult = GenerateMessDumySearchResult().ToList();
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
        List<BookSearchModel> searchResult = GenerateDumySearchResult(count: resultCount).ToList();
        const int userId = 1;

        _bookSearchRepository.Setup(repository => 
            repository.SearchBook(It.IsAny<int>(), It.IsAny<string>(), limitPerPage))
            .ReturnsAsync(searchResult);
        
        List<BookSearchReadModel> bookResult = await _bookController
            .SearchBook(userId, "anySearch", limitPerPage);
        
        Assert.NotEmpty(bookResult);
        Assert.Equal(bookResult.Count, resultCount);
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
        Assert.Equal(book.lastModification, bookUpdate.lastModification);
    }
    [Fact]
    public async void UpdateEmptyRequestTest()
    {
        UserModel user = userModelTestDumy;
        BookModel book = bookModelTestDumy;
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
        Assert.NotEqual(book.readed, bookUpdate.readed);
        Assert.NotEqual(book.tags, bookUpdate.tags);
        Assert.NotEqual(book.lastModification, bookUpdate.lastModification);
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
        _bookRepository.Setup(ex => ex.DeleteBook(book))
            .Returns(book);
        
        await _bookController.DeleteBook(It.IsAny<int>(), It.IsAny<int>());
    }
}