using AutoMapper;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Mapper.Profiles;

public class BookSearchMapperProfile : Profile
{
    public BookSearchMapperProfile()
    {
        CreateMap<BookWriteModel, BookSearchModel>();
        CreateMap<BookUpdateModel, BookSearchModel>();
    }
}