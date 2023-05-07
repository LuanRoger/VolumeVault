using AutoMapper;
using VolumeVaultInfra.Book.Search.MapperResolver;

namespace VolumeVaultInfra.Book.Search.MapperProfiles;

public class DateDateTimeMapperProfile : Profile
{
    public DateDateTimeMapperProfile()
    {
        CreateMap<Date, DateTime>().ConvertUsing<GrpcDateResolver>();
        CreateMap<DateTime, Date>().ConvertUsing<DateTimeGrpcDateResolver>();
    }
}