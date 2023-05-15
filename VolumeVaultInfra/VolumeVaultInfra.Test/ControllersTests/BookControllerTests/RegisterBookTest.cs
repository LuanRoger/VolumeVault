using FluentValidation;
using Moq;
using Serilog;
using VolumeVaultInfra.Book.Controllers;
using VolumeVaultInfra.Book.Models.Book;
using VolumeVaultInfra.Book.Models.User;
using VolumeVaultInfra.Book.Repositories;
using VolumeVaultInfra.Book.Services.Metrics;
using VolumeVaultInfra.Book.Test.ControllersTests.UserControllerTest;
using VolumeVaultInfra.Book.Validators;

namespace VolumeVaultInfra.Test.ControllersTests.BookControllerTests;

public class RegisterBookTest
{
    private Mock<IBookRepository> _bookRepository { get; } = new();
    private Mock<IBookSearchRepository> _bookSearchRepository { get; } = new();
    private Mock<IUserRepository> _userRepository { get; } = new();
    private Mock<IBookControllerMetrics> _bookControllerMetricsMock { get; } = new();
    private Mock<ILogger> _logger { get; } = new();
    private BookController _bookController { get; }
    
    public RegisterBookTest()
    {
        IValidator<BookWriteModel> bookValidator = new BookWriteModelValidator();
        IValidator<BookUpdateModel> bookUpdateValidator = new BookUpdateModelValidator();

        _bookController = new(_bookRepository.Object, _bookSearchRepository.Object, _userRepository.Object, _bookControllerMetricsMock.Object,
            bookValidator, bookUpdateValidator, _logger.Object);
    }
    
    [Fact]
    public async void RegsiterValidBookTest()
    {
        UserModel user = UserFakeModels.userTestDumy;
        BookWriteModel book = BookFakeModels.bookWriteModelTestDumy;
        
        _userRepository.Setup(ex => ex.GetUserById(It.IsAny<int>()))
            .ReturnsAsync(user);
        _bookRepository.Setup(ex => ex.AddBook(It.IsAny<BookModel>()))
            .ReturnsAsync(BookFakeModels.bookModelTestDumy);
        
        await _bookController.RegisterNewBook(user.id, book);
    }
}