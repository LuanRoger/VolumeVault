using AutoMapper;

namespace VolumeVaultInfra.Book.Search.MapperResolver;

public class GrpcDateResolver : ITypeConverter<Date, DateTime>
{
    public DateTime Convert(Date source, DateTime destination, ResolutionContext context) =>
        new(source.Year, source.Month, source.Day);
}