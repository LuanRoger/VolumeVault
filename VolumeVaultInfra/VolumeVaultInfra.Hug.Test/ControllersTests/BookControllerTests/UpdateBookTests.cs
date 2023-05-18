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

public class UpdateBookTests
{
    private Mock<IBookRepository> bookRepository { get; } = new();
    private Mock<IBookSearchRepository> bookSearchRepository { get; } = new();
    private Mock<IUserIdentifierRepository> userRepository { get; } = new();
    private Mock<IGenreRepository> genreRepository { get; } = new();
    private Mock<ITagRepository> tagRepository { get; } = new();
    //private Mock<IBookControllerMetrics> _bookControllerMetricsMock { get; } = new();
    private Mock<ILogger> logger { get; } = new();
    private BookController bookController { get; }

    public UpdateBookTests()
    {
        IValidator<BookWriteModel> bookValidator = new BookWriteModelValidator();
        IValidator<BookUpdateModel> bookUpdateValidator = new BookUpdateModelValidator();
        Mapper mapper = new(new MapperConfiguration(configure =>
        {
            configure.AddProfile<BookModelMapperProfile>();
            configure.AddProfile<BookSearchMapperProfile>();
        }));

        bookController = new(logger.Object, bookRepository.Object, genreRepository.Object,
            userRepository.Object, tagRepository.Object, bookSearchRepository.Object, mapper,
            bookValidator, bookUpdateValidator);
    }
    
    //TODO: Check tags and genres latter
    [Fact]
    public async void UpdateBookTest()
    {
        const string userIdentifier = "1";
        UserIdentifier user = new()
        {
            id = 1,
            userIdentifier = userIdentifier
        };
        BookModel book = BookFakeModels.bookModelTestDumy;
        book.owner = user;
        var bookGeneres = BookUtilsFakeModels.bookGenres;
        var bookTags = BookUtilsFakeModels.bookTags;

        BookUpdateModel bookUpdate = BookFakeModels.bookUpdateModelTestDumy;
        
        userRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(user);
        bookRepository.Setup(ex => ex.GetBookById(book.id))
            .ReturnsAsync(book);
        genreRepository.Setup(ex => ex.GetBookGenres(book))
            .ReturnsAsync(bookGeneres);
        tagRepository.Setup(ex => ex.GetBookTags(book))
            .ReturnsAsync(bookTags);
        
        await bookController.UpdateBook(bookUpdate, book.id, userIdentifier);

        Assert.Equal(book.title, bookUpdate.title);
        Assert.Equal(book.author, bookUpdate.author);
        Assert.Equal(book.isbn, bookUpdate.isbn);
        Assert.Equal(book.publicationYear, bookUpdate.publicationYear);
        Assert.Equal(book.publisher, bookUpdate.publisher);
        Assert.Equal(book.edition, bookUpdate.edition);
        Assert.Equal(book.pagesNumber, bookUpdate.pagesNumber);
        Assert.Equal(book.format, bookUpdate.format);
        Assert.Equal(book.observation, bookUpdate.observation);
        Assert.Equal(book.readStatus, bookUpdate.readStatus);
        Assert.Equal(book.lastModification, bookUpdate.lastModification);
    }
    [Fact]
    public async void UpdateEmptyRequestTest()
    {
        const string userIdentifier = "1";
        UserIdentifier user = new()
        {
            id = 1,
            userIdentifier = userIdentifier
        };
        BookModel book = BookFakeModels.bookModelTestDumy;
        book.owner = user;
        BookUpdateModel bookUpdate = new()
        {
            lastModification = DateTime.Now
        };
        
        userRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(user);
        bookRepository.Setup(ex => ex.GetBookById(book.id))
            .ReturnsAsync(book);
        
        await Assert.ThrowsAsync<NotModifiedBookException>(() => 
            bookController.UpdateBook(bookUpdate, book.id, userIdentifier));
    }
}