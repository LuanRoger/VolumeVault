using FluentValidation;
using Moq;
using Serilog;
using VolumeVaultInfra.Book.Search.Controllers;
using VolumeVaultInfra.Book.Search.Models;
using VolumeVaultInfra.Book.Search.Repositories;
using VolumeVaultInfra.Book.Search.Test.BookSearchControllerTest.FakeData;
using VolumeVaultInfra.Book.Search.Validators;

namespace VolumeVaultInfra.Book.Search.Test.BookSearchControllerTest;

public class BookSearchControllerTest
{
    private Mock<ILogger> logger { get; } = new();
    private Mock<IBookSearchRepository> bookSearchRepository { get; } = new();
    private BookSearchController bookSearchController { get; }

    public BookSearchControllerTest()
    {
        IValidator<BookSearchRequest> bookSearchRequestValidator = new BookSearchRequestValidator();
        bookSearchController = new(bookSearchRepository.Object, bookSearchRequestValidator, logger.Object);
    }
    
    [Fact]
    public async void SearchBookTest()
    {
        BookSearchRequest request = BookSearchFakeData.fakeBookSearchRequest;
        SearchRepositoryResult repositoryResult = BookSearchFakeData.fakeSearchResultModel;
        bookSearchRepository.Setup(repository => repository.SearchBook(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>()))
            .ReturnsAsync(repositoryResult);
        
        SearchResultModel resultModel = await bookSearchController.SearchBook(request);
        
        Assert.Equal(repositoryResult.hints.Count, resultModel.count);
        Assert.Equal(repositoryResult.hints, resultModel.results);
        Assert.Equal(repositoryResult.searchElapsedTime, resultModel.searchElapsedTime);
    }
}