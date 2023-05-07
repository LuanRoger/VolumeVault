using AutoMapper;
using VolumeVaultInfra.Book.Search.MapperResolver;
using VolumeVaultInfra.Book.Search.Models;

namespace VolumeVaultInfra.Book.Search.MapperProfiles;

public class GrpcBookSearchModelMapperProfile : Profile
{
    public GrpcBookSearchModelMapperProfile()
    {
        CreateMap<GrpcBookSearchModel, BookSearchModel>()
            .ConvertUsing<GrpcBookSearchModelBookSearchModelResolver>();
        CreateMap<BookSearchModel, GrpcBookSearchModel>();
    }
}