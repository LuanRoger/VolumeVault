using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public interface IBadgeRepository
{
    public Task<BadgeModel?> GetBadgeByCode(BadgeCodes code);
    public Task<IReadOnlyList<BadgeModel>> GetUserBadges(UserIdentifier user);
    public Task GiveBadgeToUser(UserIdentifier user, BadgeCodes badgeCode);
    public Task RemoveBadgeFromUser(UserIdentifier user, BadgeCodes badgeCode);
    public Task Flush();
}