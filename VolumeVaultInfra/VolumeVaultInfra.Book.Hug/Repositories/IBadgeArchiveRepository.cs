using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public interface IBadgeArchiveRepository
{
    public Task<BadgeModel> AttachBadgeToEmail(EmailUserIdentifier emailUserIdentifier, BadgeCode code);
    public Task<BadgeModel?> DetachBadgeToEmail(EmailUserIdentifier emailUserIdentifier, BadgeCode code);
    public Task<IReadOnlyList<BadgeModel>> DetachBadgesToEmail(EmailUserIdentifier emailUserIdentifier);
    public Task Flush();
}