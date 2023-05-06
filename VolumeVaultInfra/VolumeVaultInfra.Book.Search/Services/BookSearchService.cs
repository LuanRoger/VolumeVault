using System.Collections.Immutable;
using AutoMapper;
using Google.Protobuf.Collections;
using Google.Protobuf.WellKnownTypes;
using Grpc.Core;
using VolumeVaultInfra.Book.Search.Models;
using VolumeVaultInfra.Book.Search.Repositories;

namespace VolumeVaultInfra.Book.Search.Services;

public class BookSearchService : Search.SearchBase
{
    private IBookSearchRepository searchRepository { get; }
    private IMapper mapper { get; }
    
    public BookSearchService(IBookSearchRepository searchRepository, IMapper mapper)
    {
        this.searchRepository = searchRepository;
        this.mapper = mapper;
    }

    public override async Task<Empty> MadeBookSearchable(GrpcBookSearchModel request, ServerCallContext context)
    {
        BookSearchModel searchModel = mapper.Map<BookSearchModel>(request);
        
        await searchRepository.MadeBookSearchable(searchModel);
        
        return new();
    }

    public override async Task SearchBook(SearchRequest request, IServerStreamWriter<GrpcBookSearchModel> responseStream, ServerCallContext context)
    {
        var searchResults = 
            await searchRepository.SearchBook(request.UserId, request.Query, request.LimitPerSection);

        foreach (BookSearchModel result in searchResults)
        {
            GrpcBookSearchModel searchResponse = mapper.Map<GrpcBookSearchModel>(result);
            await responseStream.WriteAsync(searchResponse);
        }
    }
}