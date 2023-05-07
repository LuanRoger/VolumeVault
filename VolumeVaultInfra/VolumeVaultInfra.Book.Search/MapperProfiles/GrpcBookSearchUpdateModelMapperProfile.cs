using AutoMapper;
using VolumeVaultInfra.Book.Search.MapperResolver;
using VolumeVaultInfra.Book.Search.Models;

namespace VolumeVaultInfra.Book.Search.MapperProfiles;

public class GrpcBookSearchUpdateModelMapperProfile : Profile
{
    public GrpcBookSearchUpdateModelMapperProfile()
    {
        CreateMap<GrpcBookSearchUpdateModel, BookSearchUpdateModel>()
            .ConvertUsing<GrpcBookSearchUpdateModelBookSearchModelResolver>();
    }
}