using AutoMapper;
using VolumeVaultInfra.Book.Hug.Mapper.Resolvers;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Mapper.Profiles;

public class BadgeModelBadgeReadModelMapperProfile : Profile
{
    public BadgeModelBadgeReadModelMapperProfile()
    {
        CreateMap<BadgeModel, BadgeReadModel>()
            .ConvertUsing<BadgeModelBadgeReadModelMapperResolver>();
    }
}