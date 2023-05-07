using AutoMapper;
using FluentValidation;
using FluentValidation.Results;
using Google.Protobuf.WellKnownTypes;
using Grpc.Core;
using VolumeVaultInfra.Book.Search.Exceptions;
using VolumeVaultInfra.Book.Search.Models;
using VolumeVaultInfra.Book.Search.Repositories;
using ILogger = Serilog.ILogger;

namespace VolumeVaultInfra.Book.Search.Services;

public class BookSearchService : Search.SearchBase
{
    private IBookSearchRepository searchRepository { get; }
    private IMapper mapper { get; }
    private IValidator<BookSearchModel> searchModelValidator { get; }
    private IValidator<BookSearchUpdateModel> updateModelValidator { get; }
    private ILogger logger { get; }

    public BookSearchService(IBookSearchRepository searchRepository, IMapper mapper,
        IValidator<BookSearchModel> searchModelValidator,
        IValidator<BookSearchUpdateModel> updateModelValidator, ILogger logger)
    {
        this.searchRepository = searchRepository;
        this.mapper = mapper;
        this.searchModelValidator = searchModelValidator;
        this.updateModelValidator = updateModelValidator;
        this.logger = logger;
    }

    public override async Task<Empty> MadeBookSearchable(GrpcBookSearchModel request, ServerCallContext context)
    {
        BookSearchModel searchModel = mapper.Map<BookSearchModel>(request);
        ValidationResult validationResult = await searchModelValidator.ValidateAsync(searchModel);
        if(!validationResult.IsValid)
        {
            NotValidBookInformationException exception = new(validationResult
                .Errors
                .Select(error => error.ErrorMessage));
            logger.Error(exception, "The book informations is not valid");
            
            throw new RpcException(new(StatusCode.InvalidArgument, exception.Message));
        }

        await searchRepository.MadeBookSearchable(searchModel);
        
        return new();
    }

    public override async Task<Empty> UpdateSearchBook(UpdateBookRequest request, ServerCallContext context)
    {
        BookSearchUpdateModel updateSearchModel = mapper.Map<BookSearchUpdateModel>(request.Book);
        ValidationResult validationResult = await updateModelValidator.ValidateAsync(updateSearchModel);
        if(!validationResult.IsValid)
        {
            NotValidBookInformationException exception = new(validationResult
                .Errors
                .Select(error => error.ErrorMessage));
            logger.Error(exception, "The book informations is not valid");
            
            throw new RpcException(new(StatusCode.InvalidArgument, exception.Message));
        }
        BookSearchModel? bookToUpdate = await searchRepository.GetBookInSearchById(request.BookId, request.UserId);
        if(bookToUpdate is null)
        {
            BookNotFoundException exception = new(request.BookId);
            logger.Error(exception, "The book was not found");
            
            throw new RpcException(new(StatusCode.NotFound, exception.Message));
        }

        BookSearchModel updatedBookModel = new()
        {
            id = bookToUpdate.id,
            title = updateSearchModel.title ?? bookToUpdate.title,
            author = updateSearchModel.author ?? bookToUpdate.author,
            isbn = updateSearchModel.isbn ?? bookToUpdate.isbn,
            publicationYear = updateSearchModel.publicationYear ?? bookToUpdate.publicationYear,
            publisher = updateSearchModel.publisher ?? bookToUpdate.publisher,
            edition = updateSearchModel.edition ?? bookToUpdate.edition,
            pagesNumber = updateSearchModel.pagesNumber ?? bookToUpdate.pagesNumber,
            genre = updateSearchModel.genre ?? bookToUpdate.genre,
            format = updateSearchModel.format ?? bookToUpdate.format,
            readStatus = updateSearchModel.readStatus ?? bookToUpdate.readStatus,
            readStartDay = updateSearchModel.readStartDay ?? bookToUpdate.readStartDay,
            readEndDay = updateSearchModel.readEndDay ?? bookToUpdate.readEndDay,
            tags = updateSearchModel.tags ?? bookToUpdate.tags,
            createdAt = bookToUpdate.createdAt,
            lastModification = DateTime.Now,
            ownerId = bookToUpdate.ownerId,
        };
        

        await searchRepository.UpdateSearchBook(request.BookId, updatedBookModel);
        
        return new();
    }

    public override async Task<Empty> DeleteBookFromSearch(DeleteBookRequest request, ServerCallContext context)
    {
        BookSearchModel? bookToUpdate = await searchRepository.GetBookInSearchById(request.BookId, request.UserId);
        if(bookToUpdate is null)
        {
            BookNotFoundException exception = new(request.BookId);
            logger.Error(exception, "The book was not found");
            
            throw new RpcException(new(StatusCode.NotFound, exception.Message));
        }
        
        await searchRepository.DeleteBookFromSearch(request.BookId);
        
        return new();
    }

    public override async Task SearchBook(IAsyncStreamReader<SearchRequest> requestStream, 
        IServerStreamWriter<GrpcBookSearchModel> responseStream, 
        ServerCallContext context)
    {
        while (!context.CancellationToken.IsCancellationRequested && await requestStream.MoveNext())
        {
            var searchResults = 
                await searchRepository.SearchBook(requestStream.Current.UserId, 
                    requestStream.Current.Query, 
                    requestStream.Current.LimitPerSection);

            foreach (BookSearchModel result in searchResults)
            {
                GrpcBookSearchModel searchResponse = mapper.Map<GrpcBookSearchModel>(result);
                await responseStream.WriteAsync(searchResponse);
            }
        }
    }
}