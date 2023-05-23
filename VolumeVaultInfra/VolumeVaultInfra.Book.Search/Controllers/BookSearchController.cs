using FluentValidation;
using FluentValidation.Results;
using VolumeVaultInfra.Book.Search.Exceptions;
using VolumeVaultInfra.Book.Search.Models;
using VolumeVaultInfra.Book.Search.Repositories;
using ILogger = Serilog.ILogger;

namespace VolumeVaultInfra.Book.Search.Controllers;

public class BookSearchController : IBookSearchController
{
    private IBookSearchRepository searchRepository { get; }
    private IValidator<BookSearchRequest> searchRequestValidator { get; }
    private ILogger logger { get; }

    public BookSearchController(IBookSearchRepository searchRepository, 
        IValidator<BookSearchRequest> searchRequestValidator, 
        ILogger logger)
    {
        this.searchRepository = searchRepository;
        this.searchRequestValidator = searchRequestValidator;
        this.logger = logger;
    }
    
    public async Task<SearchResultModel> SearchBook(BookSearchRequest searchRequest)
    {
        ValidationResult validationResult = await searchRequestValidator.ValidateAsync(searchRequest);
        if(!validationResult.IsValid)
        {
            NotValidBookInformationException exception = new(validationResult.Errors
                .Select(error => error.ErrorMessage));
            logger.Error(exception, "Book search request is not valid");
            
            throw exception;
        }

        SearchRepositoryResult searchResults = 
            await searchRepository.SearchBook(searchRequest.userId,
                searchRequest.query,
                searchRequest.limitPerSection);
            
        return new()
        {
            count = searchResults.hints.Count,
            results = searchResults.hints,
            searchElapsedTime = searchResults.searchElapsedTime
        };
    }
}