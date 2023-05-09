using AutoMapper;
using VolumeVaultInfra.Book.Hug.Mapper.Resolvers;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Mapper.Profiles;

public class BookModelProfile : Profile
{
    public BookModelProfile()
    {
        CreateMap<BookWriteModel, BookModel>();
        CreateMap<BookModel, GrpcBookModel>()
            .ConvertUsing<BookModelGrpcBookModelMapperResolver>();
    }
}