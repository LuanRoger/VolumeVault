using AutoMapper;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Mapper.Resolvers;

public class BadgeModelBadgeReadModelMapperResolver : ITypeConverter<BadgeModel, BadgeReadModel>
{
    public BadgeReadModel Convert(BadgeModel source, BadgeReadModel destination, ResolutionContext context) =>
        new()
        {
            count = 1,
            badgeCodes = new List<BadgeCodes> { source.code }
        };
}