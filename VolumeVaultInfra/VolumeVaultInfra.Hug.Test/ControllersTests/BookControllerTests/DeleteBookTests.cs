using AutoMapper;
using FluentValidation;
using Moq;
using Serilog;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Repositories;
using VolumeVaultInfra.Book.Hug.Repositories.Search;
using VolumeVaultInfra.Book.Hug.Validators;
using VolumeVaultInfra.Hug.Test.ControllersTests.BookControllerTests.FakeData;

namespace VolumeVaultInfra.Hug.Test.ControllersTests.BookControllerTests;

public class DeleteBookTests
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

    public DeleteBookTests()
    {
        IValidator<BookWriteModel> bookValidator = new BookWriteModelValidator();
        IValidator<BookUpdateModel> bookUpdateValidator = new BookUpdateModelValidator();

        bookController = new(logger.Object, bookRepository.Object, genreRepository.Object,
            userRepository.Object, tagRepository.Object, bookSearchRepository.Object, mapper.Object,
            bookValidator, bookUpdateValidator);
    }
    
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
        bookRepository.Setup(ex => ex.GetBookById(It.IsAny<int>()))
            .ReturnsAsync(book);
        bookRepository.Setup(ex => ex.DeleteBook(book))
            .Returns(book);
        
        await bookController.RemoveBook(It.IsAny<int>(), userIdentifier);
    }
}