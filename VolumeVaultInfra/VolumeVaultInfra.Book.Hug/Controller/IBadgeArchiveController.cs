using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Controller;

public interface IBadgeArchiveController
{
    public Task<BadgeReadModel> AttachBadgeToEmail(AttachBadgeToEmailRequest requestInfo);
    public Task<BadgeReadModel?> DetachBadgeFromEmail(string email, BadgeCode code);
    public Task<BadgeReadModel> GetUserBadgesOnArchive(string email);
    public Task<BadgeReadModel> ClaimBadgeFromEmailInArchive(ClaimUserBadgesRequest requestInfo);
}