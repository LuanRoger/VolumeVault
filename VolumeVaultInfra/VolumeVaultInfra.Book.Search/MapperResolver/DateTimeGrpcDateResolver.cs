using AutoMapper;

namespace VolumeVaultInfra.Book.Search.MapperResolver;

public class DateTimeGrpcDateResolver : ITypeConverter<DateTime, Date>
{
    public Date Convert(DateTime source, Date destination, ResolutionContext context) =>
        new()
        {
            Day = source.Day,
            Month = source.Month,
            Year = source.Year
        };
}