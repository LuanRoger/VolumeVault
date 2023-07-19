using AutoMapper;
using FluentValidation;
using Moq;
using Serilog;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Mapper.Profiles;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Utils;
using VolumeVaultInfra.Book.Hug.Repositories;
using VolumeVaultInfra.Book.Hug.Repositories.Search;
using VolumeVaultInfra.Book.Hug.Validators;
using VolumeVaultInfra.Hug.Test.ControllersTests.BookControllerTests.FakeData;

namespace VolumeVaultInfra.Hug.Test.ControllersTests.BookControllerTests;

public class BookControllerTest
{
    private Mock<IBookRepository> bookRepository { get; } = new();
    private Mock<IBookSearchRepository> bookSearchRepository { get; } = new();
    private Mock<IUserIdentifierRepository> userRepository { get; } = new();
    private Mock<IGenreRepository> genreRepository { get; } = new();
    private Mock<ITagRepository> tagRepository { get; } = new();
    private Mock<ILogger> logger { get; } = new();
    private BookController bookController { get; }

    public BookControllerTest()
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

    #region Get
    
    [Fact]
    public async void GetSingleBookInfoTest()
    {
        const string userIdentifier = "1";
        UserIdentifier user = new()
        {
            id = 1,
            userIdentifier = userIdentifier
        };
        BookModel returnedBooModel = BookFakeModels.bookModelTestDumy;
        // returnedBooModel.owner = user; The owner is not the same by default
        
        userRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(user);
        genreRepository.Setup(ex => ex.GetBookGenres(It.IsAny<BookModel>()))
            .ReturnsAsync(BookUtilsFakeModels.bookGenres);
        tagRepository.Setup(ex => ex.GetBookTags(It.IsAny<BookModel>()))
            .ReturnsAsync(BookUtilsFakeModels.bookTags);
        bookRepository.Setup(ex => 
                ex.GetBookById(It.IsAny<Guid>()))
            .ReturnsAsync(returnedBooModel);
        
        await Assert.ThrowsAsync<NotOwnerBookException>(() => bookController
            .GetBookById(returnedBooModel.id.ToString(), userIdentifier));
    }
    
    [Theory]
    [InlineData(1, 10)]
    [InlineData(1, 20)]
    [InlineData(1, 5)]
    [InlineData(2, 10)]
    [InlineData(2, 20)]
    public async void GetBookFromUserTest(int page, int limitPerPage)
    {
        const string userIdentifier = "1";
        UserIdentifier user = new()
        {
            id = 1,
            userIdentifier = userIdentifier
        };
        BookSortOptions sortOptions = BookUtilsFakeModels.defaultBookSortOptions;
        BookResultLimiter resultLimiter = BookUtilsFakeModels.defaultBookResultLimiter;
        
        var dumyBooks = BookFakeGenerators.GenerateDumyBooks(limitPerPage).ToList();
        
        userRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(user);
        genreRepository.Setup(ex => ex.GetBookGenres(It.IsAny<BookModel>()))
            .ReturnsAsync(BookUtilsFakeModels.bookGenres);
        tagRepository.Setup(ex => ex.GetBookTags(It.IsAny<BookModel>()))
            .ReturnsAsync(BookUtilsFakeModels.bookTags);
        bookRepository.Setup(ex => 
            ex.GetUserOwnedBooksSplited(user, page, limitPerPage,  
                It.IsAny<BookResultLimiter>(), It.IsAny<BookSortOptions>()))
            .ReturnsAsync(dumyBooks);
        
        BookUserRelatedReadModel booksResult = await bookController
            .GetUserOwnedBooks(user.userIdentifier, page, limitPerPage, 
                resultLimiter, sortOptions);
        
        Assert.Equal(page, booksResult.page);
        Assert.Equal(limitPerPage, booksResult.limitPerPage);
    }
    
    [Fact]
    public async void GetUserBooksGenres()
    {
        const string userIdentifier = "1";
        UserIdentifier user = new()
        {
            id = 1,
            userIdentifier = userIdentifier
        };
        var genreModels = BookUtilsFakeModels.bookGenres;
        
        userRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(user);
        genreRepository.Setup(ex => ex.GetUserGenres(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(genreModels);
        
        GenresReadModel genresResult = await bookController.GetUserBooksGenres(userIdentifier);

        Assert.Equal(genreModels.Count, genresResult.count);
        Assert.Equal(genreModels.Select(genre => genre.genre), genresResult.genres);
    }

    #endregion

    #region Search

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
        bookRepository.Setup(ex => ex.GetBookById(It.IsAny<Guid>()))
            .ReturnsAsync(book);
        genreRepository.Setup(ex => ex.GetBookGenres(book))
            .ReturnsAsync(bookGeneres);
        tagRepository.Setup(ex => ex.GetBookTags(book))
            .ReturnsAsync(bookTags);
        
        await bookController.UpdateBook(bookUpdate, book.id.ToString(), userIdentifier);

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
        bookRepository.Setup(ex => ex.GetBookById(It.IsAny<Guid>()))
            .ReturnsAsync(book);
        
        await Assert.ThrowsAsync<NotModifiedBookException>(() => 
            bookController.UpdateBook(bookUpdate, book.id.ToString(), userIdentifier));
    }

    #endregion

    #region Register

    [Fact]
    public async void RegsiterValidBookTest()
    {
        const string userIdentifier = "1";
        UserIdentifier user = new()
        {
            id = 1,
            userIdentifier = userIdentifier
        };
        BookWriteModel bookWrite = BookFakeModels.bookWriteModelTestDumy;
        
        userRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(user);
        bookRepository.Setup(ex => ex.AddBook(It.IsAny<BookModel>()))
            .ReturnsAsync(BookFakeModels.bookModelTestDumy);
        
        await bookController.RegisterNewBook(bookWrite, userIdentifier);
    }

    #endregion
    
    #region Delete
    
    [Fact]
    public async void DeleteBookTest()
    {
        const string userIdentifier = "1";
        UserIdentifier user = new()
        {
            id = 1,
            userIdentifier = userIdentifier
        };
        
        BookModel book = BookFakeModels.bookModelTestDumy;
        book.owner = user;
        
        userRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(user);
        bookRepository.Setup(ex => ex.GetBookById(It.IsAny<Guid>()))
            .ReturnsAsync(book);
        bookRepository.Setup(ex => ex.DeleteBook(book))
            .Returns(book);
        
        await bookController.RemoveBook(book.id.ToString(), userIdentifier);
    }

    #endregion
}