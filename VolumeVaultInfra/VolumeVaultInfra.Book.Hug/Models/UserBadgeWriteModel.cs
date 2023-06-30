using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Models;

public class UserBadgeWriteModel
{
    public required string userId { get; init; }
    public required BadgeCode badgeCode { get; init; }
}