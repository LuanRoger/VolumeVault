using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Controller;

public interface IBadgeController
{
    public Task<BadgeReadModel> GetUserBadges(string userId);
    public Task<BadgeReadModel> GiveBadgeToUser(GiveUserBadgeRequest giveUserBadgeRequest);
    public Task<BadgeReadModel> RemoveBadgeFromUser(string userId, BadgeCode badgeCode);
}