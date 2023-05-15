using AutoMapper;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Mapper.Profiles;

public class BookModelMapperProfile : Profile
{
    public BookModelMapperProfile()
    {
        CreateMap<BookWriteModel, BookModel>();
    }
}