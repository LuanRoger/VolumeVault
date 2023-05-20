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