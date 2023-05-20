using AutoMapper;
using FluentValidation;
using Moq;
using Serilog;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Mapper.Profiles;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Repositories;
using VolumeVaultInfra.Book.Hug.Repositories.Search;
using VolumeVaultInfra.Book.Hug.Validators;
using VolumeVaultInfra.Hug.Test.ControllersTests.BookControllerTests.FakeData;

namespace VolumeVaultInfra.Hug.Test.ControllersTests.BookControllerTests;

public class RegisterBookTest
{
    private Mock<IBookRepository> bookRepository { get; } = new();
    private Mock<IBookSearchRepository> bookSearchRepository { get; } = new();
    private Mock<IUserIdentifierRepository> userRepository { get; } = new();
    private Mock<IGenreRepository> genreRepository { get; } = new();
    private Mock<ITagRepository> tagRepository { get; } = new();
    private Mock<ILogger> logger { get; } = new();
    private BookController bookController { get; }
    
    public RegisterBookTest()
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
        
        await bookController.CreateBook(bookWrite, userIdentifier);
    }
}