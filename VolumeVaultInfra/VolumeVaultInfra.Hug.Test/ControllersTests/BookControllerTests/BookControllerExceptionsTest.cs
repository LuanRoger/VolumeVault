using AutoMapper;
using FluentValidation;
using Moq;
using Serilog;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Mapper.Profiles;
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
    private BookController bookController { get; }

    public BookControllerExceptionsTest()
    {
        IValidator<BookWriteModel> bookValidator = new BookWriteModelValidator();
        IValidator<BookUpdateModel> bookUpdateValidator = new BookUpdateModelValidator();
        IMapper mapper = new Mapper(new MapperConfiguration(configure =>
        {
            configure.AddProfile<BookModelMapperProfile>();
            configure.AddProfile<BookSearchMapperProfile>();
        }));

        bookController = new(logger.Object, bookRepository.Object, genreRepository.Object,
            userRepository.Object, tagRepository.Object, bookSearchRepository.Object, mapper,
            bookValidator, bookUpdateValidator);
    }
    
    private const string USER_IDENTIFIER = "1";
    
    [Fact]
    public async void GetBookInfoByIdBookNotFoundExceptionTest()
    {
        const string userIdentifier = "1";
        string bookId = BookFakeModels.bookModelTestDumy.id.ToString();
        UserIdentifier user = new()
        {
            id = 1,
            userIdentifier = userIdentifier
        };
        BookModel? returnedBooModel = null;

        userRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(user);
        genreRepository.Setup(ex => ex.GetBookGenres(It.IsAny<BookModel>()))
            .ReturnsAsync(BookUtilsFakeModels.bookGenres);
        tagRepository.Setup(ex => ex.GetBookTags(It.IsAny<BookModel>()))
            .ReturnsAsync(BookUtilsFakeModels.bookTags);
        bookRepository.Setup(ex => 
                ex.GetBookById(It.IsAny<Guid>()))
            .ReturnsAsync(returnedBooModel);
        
        await Assert.ThrowsAsync<BookNotFoundException>(() => bookController
            .GetBookById(bookId, userIdentifier));
    }
    [Fact]
    public async void GetSingleBookInfoTest()
    {
        const string userIdentifier = "1";
        string bookId = BookFakeModels.bookModelTestDumy.id.ToString();
        UserIdentifier user = new()
        {
            id = 1,
            userIdentifier = userIdentifier
        };
        BookModel returnedBooModel = BookFakeModels.bookModelTestDumy;
        returnedBooModel.owner = user;
        
        userRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(user);
        genreRepository.Setup(ex => ex.GetBookGenres(It.IsAny<BookModel>()))
            .ReturnsAsync(BookUtilsFakeModels.bookGenres);
        tagRepository.Setup(ex => ex.GetBookTags(It.IsAny<BookModel>()))
            .ReturnsAsync(BookUtilsFakeModels.bookTags);
        bookRepository.Setup(ex => 
                ex.GetBookById(It.IsAny<Guid>()))
            .ReturnsAsync(returnedBooModel);
        
        BookReadModel booksResult = await bookController
            .GetBookById(bookId, userIdentifier);
        
        Assert.Equal(returnedBooModel.id, booksResult.id);
        Assert.Equal(returnedBooModel.title, booksResult.title);
        Assert.Equal(returnedBooModel.author, booksResult.author);
        Assert.Equal(returnedBooModel.isbn, booksResult.isbn);
    }
    
    [Fact]
    public void RegisterInvalidBookTest()
    {
        BookWriteModel invalidBook = BookFakeModels.invalidBookWriteModelTestDumy;
        
        Assert.ThrowsAsync<InvalidBookInformationException>(() => 
            bookController.RegisterNewBook(invalidBook, USER_IDENTIFIER));
    }
    [Fact]
    public async void UpdateInvalidBookTest()
    {
        BookUpdateModel invalidBookUpdate = BookFakeModels.invalidBookUpdateModelTestDumy;
        await Assert.ThrowsAsync<InvalidBookInformationException>(() => 
            bookController.UpdateBook(invalidBookUpdate, It.IsAny<string>(), USER_IDENTIFIER));
    }

    [Fact]
    public async void NotFoundBookToUpdateTest()
    {
        UserIdentifier user = new()
        {
            id = 1,
            userIdentifier = USER_IDENTIFIER
        };
        BookUpdateModel bookUpdate = BookFakeModels.bookUpdateModelTestDumy;
        string bookId = BookFakeModels.bookModelTestDumy.id.ToString();
        
        userRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(user);
        bookRepository.Setup(ex => ex.GetBookById(It.IsAny<Guid>()))
            .ReturnsAsync(() => null);
        
        await Assert.ThrowsAsync<BookNotFoundException>(() =>
            bookController.UpdateBook(bookUpdate, bookId, USER_IDENTIFIER));
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
            bookController.UpdateBook(bookUpdate, book.id.ToString(), USER_IDENTIFIER));
    }

    [Fact]
    public async void NotRegistredBookBeingDeletedTest()
    {
        UserIdentifier user = new()
        {
            id = 1,
            userIdentifier = USER_IDENTIFIER
        };
        string bookId = BookFakeModels.bookModelTestDumy.id.ToString();

        userRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(user);
        bookRepository.Setup(ex => ex.GetBookById(It.IsAny<Guid>()))
            .ReturnsAsync(() => null);
        
        await Assert.ThrowsAsync<BookNotFoundException>(() => 
            bookController.RemoveBook(bookId, USER_IDENTIFIER));
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
        bookRepository.Setup(ex => ex.GetBookById(It.IsAny<Guid>()))
            .ReturnsAsync(book);
        
        await Assert.ThrowsAsync<NotOwnerBookException>(() => 
            bookController.RemoveBook(book.id.ToString(), USER_IDENTIFIER));
    }
}