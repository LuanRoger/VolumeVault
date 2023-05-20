using AutoMapper;
using FluentValidation;
using Moq;
using Serilog;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Enums;
using VolumeVaultInfra.Book.Hug.Repositories;
using VolumeVaultInfra.Book.Hug.Repositories.Search;
using VolumeVaultInfra.Book.Hug.Validators;

namespace VolumeVaultInfra.Hug.Test.ControllersTests;

public class BookControllerExceptionsTest
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

    public BookControllerExceptionsTest()
    {
        IValidator<BookWriteModel> bookValidator = new BookWriteModelValidator();
        IValidator<BookUpdateModel> bookUpdateValidator = new BookUpdateModelValidator();

        bookController = new(logger.Object, bookRepository.Object, genreRepository.Object,
            userRepository.Object, tagRepository.Object, bookSearchRepository.Object, mapper.Object,
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
        format = 0,
        observation = "test",
        synopsis = "test",
        coverLink = "test",
        buyLink = "test",
        readStatus = ReadStatus.HasReaded,
        readStartDay = new DateTime(2023, 1, 1),
        readEndDay = new DateTime(2023, 1, 7),
        createdAt = DateTime.Today,
        lastModification = DateTime.Today,
        owner = new()
        {
            id = 1,
            userIdentifier = "1"
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
        genre = new() { "changed" },
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
        genre = new() { "changed" },
        format = BookFormat.HARDBACK,
        observation = "changed",
        synopsis = "changed",
        coverLink = "changed",
        buyLink = "changed",
        readStatus = ReadStatus.NotRead,
        tags = new() { "changed", "changed" }
    };
    private const string USER_IDENTIFIER = "1";
    
    [Fact]
    public void RegisterInvalidBookTest()
    {
        BookWriteModel invalidBook = invalidBookWriteModelTestDumy;
        
        Assert.ThrowsAsync<NotValidBookInformationException>(() => 
            bookController.CreateBook(invalidBook, USER_IDENTIFIER));
    }
    [Fact]
    public async void UpdateInvalidBookTest()
    {
        BookUpdateModel invalidBookUpdate = invalidBookUpdateModelTestDumy;
        await Assert.ThrowsAsync<NotValidBookInformationException>(() => 
            bookController.UpdateBook(invalidBookUpdate, It.IsAny<int>(), USER_IDENTIFIER));
    }

    [Fact]
    public async void NotFoundBookToUpdateTest()
    {
        UserIdentifier user = new()
        {
            id = 1,
            userIdentifier = USER_IDENTIFIER
        };
        
        userRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(user);
        bookRepository.Setup(ex => ex.GetBookById(It.IsAny<int>()))
            .ReturnsAsync(() => null);
        
        await Assert.ThrowsAsync<BookNotFoundException>(() =>
            bookController.UpdateBook(bookUpdateModelTestDumy, It.IsAny<int>(), USER_IDENTIFIER));
    }
    
    [Fact]
    public async void BookDontOwnerByUserTest()
    {
        UserIdentifier user = new()
        {
            id = 1,
            userIdentifier = USER_IDENTIFIER
        };
        UserIdentifier diferentUser = new()
        {
            id = 2,
            userIdentifier = "2"
        };
        BookModel book = bookModelTestDumy;
        book.owner = diferentUser;
        BookUpdateModel bookUpdate = bookUpdateModelTestDumy;
        
        userRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(user);
        bookRepository.Setup(ex => ex.GetBookById(book.id))
            .ReturnsAsync(book);
        
        await Assert.ThrowsAsync<NotOwnerBookException>(() => 
            bookController.UpdateBook(bookUpdate, book.id, USER_IDENTIFIER));
    }

    [Fact]
    public async void NotRegistredBookBeingDeletedTest()
    {
        UserIdentifier user = new()
        {
            id = 1,
            userIdentifier = USER_IDENTIFIER
        };

        userRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(user);
        bookRepository.Setup(ex => ex.GetBookById(It.IsAny<int>()))
            .ReturnsAsync(() => null);
        
        await Assert.ThrowsAsync<BookNotFoundException>(() => 
            bookController.RemoveBook(It.IsAny<int>(), USER_IDENTIFIER));
    }
    
    [Fact]
    public async void DeleteNotOwnedUserBookTest()
    {
        UserIdentifier user = new()
        {
            id = 1,
            userIdentifier = USER_IDENTIFIER
        };
        UserIdentifier diferentUser = new()
        {
            id = 2,
            userIdentifier = "2"
        };
        BookModel book = bookModelTestDumy;
        book.owner = diferentUser;
        
        userRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(user);
        bookRepository.Setup(ex => ex.GetBookById(It.IsAny<int>()))
            .ReturnsAsync(book);
        
        await Assert.ThrowsAsync<NotOwnerBookException>(() => 
            bookController.RemoveBook(It.IsAny<int>(), USER_IDENTIFIER));
    }
}