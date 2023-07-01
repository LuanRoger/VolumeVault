using AutoMapper;
using FluentValidation;
using Moq;
using Serilog;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Repositories;
using VolumeVaultInfra.Book.Hug.Repositories.Search;
using VolumeVaultInfra.Book.Hug.Validators;
using VolumeVaultInfra.Hug.Test.ControllersTests.BookControllerTests.FakeData;

namespace VolumeVaultInfra.Hug.Test.ControllersTests.BookControllerTests;

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
    
    private const string USER_IDENTIFIER = "1";
    
    [Fact]
    public void RegisterInvalidBookTest()
    {
        BookWriteModel invalidBook = BookFakeModels.invalidBookWriteModelTestDumy;
        
        Assert.ThrowsAsync<InvalidBookInformationException>(() => 
            bookController.CreateBook(invalidBook, USER_IDENTIFIER));
    }
    [Fact]
    public async void UpdateInvalidBookTest()
    {
        BookUpdateModel invalidBookUpdate = BookFakeModels.invalidBookUpdateModelTestDumy;
        await Assert.ThrowsAsync<InvalidBookInformationException>(() => 
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
            bookController.UpdateBook(BookFakeModels.bookUpdateModelTestDumy, It.IsAny<int>(), USER_IDENTIFIER));
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
        BookModel book = BookFakeModels.bookModelTestDumy;
        book.owner = diferentUser;
        BookUpdateModel bookUpdate = BookFakeModels.bookUpdateModelTestDumy;
        
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
        BookModel book = BookFakeModels.bookModelTestDumy;
        book.owner = diferentUser;
        
        userRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(user);
        bookRepository.Setup(ex => ex.GetBookById(It.IsAny<int>()))
            .ReturnsAsync(book);
        
        await Assert.ThrowsAsync<NotOwnerBookException>(() => 
            bookController.RemoveBook(It.IsAny<int>(), USER_IDENTIFIER));
    }
}