using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Controller;

public interface IBadgeArchiveController
{
    public Task<BadgeReadModel> AttachBadgeToEmail(string email, BadgeCodes code);
    public Task<BadgeReadModel?> DetachBadgeToEmail(string email, BadgeCodes code);
    public Task ClaimBadgeFromEmailInArchive(string email);
}