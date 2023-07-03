using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Models;

public class AttachBadgeToEmailInfo
{
    public BadgeCode badgeCode { get; init; }
    public DateTime attachDate { get; init; }
}