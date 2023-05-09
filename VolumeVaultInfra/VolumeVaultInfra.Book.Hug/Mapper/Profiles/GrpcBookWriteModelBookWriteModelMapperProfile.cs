using AutoMapper;
using VolumeVaultInfra.Book.Hug.Mapper.Resolvers;
using VolumeVaultInfra.Book.Hug.Models;

namespace VolumeVaultInfra.Book.Hug.Mapper.Profiles;

public class GrpcBookWriteModelBookWriteModelMapperProfile : Profile
{
    public GrpcBookWriteModelBookWriteModelMapperProfile()
    {
        CreateMap<GrpcBookWriteModel, BookWriteModel>()
            .ConvertUsing<GrpcBookWriteModelBookWriteModelMapperResolver>();
    }
}