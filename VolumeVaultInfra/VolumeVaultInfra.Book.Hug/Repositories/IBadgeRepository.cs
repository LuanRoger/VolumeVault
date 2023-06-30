using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public interface IBadgeRepository
{
    public Task<BadgeModel?> GetBadgeByCode(BadgeCode code);
    public Task<IReadOnlyList<BadgeModel>> GetUserBadges(UserIdentifier user);
    public Task<BadgeModel> GiveBadgeToUser(UserIdentifier user, BadgeCode badgeCode);
    public Task<BadgeModel> RemoveBadgeFromUser(UserIdentifier user, BadgeCode badgeCode);
    public Task Flush();
}