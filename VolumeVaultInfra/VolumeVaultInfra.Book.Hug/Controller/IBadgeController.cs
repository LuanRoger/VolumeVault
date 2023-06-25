using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Controller;

public interface IBadgeController
{
    public Task<BadgeReadModel> GetUserBadges(string userId);
    public Task GiveBadgeToUser(string userId, BadgeCodes badgeCode);
    public Task RemoveBadgeFromUser(string userId, BadgeCodes badgeCode);
}