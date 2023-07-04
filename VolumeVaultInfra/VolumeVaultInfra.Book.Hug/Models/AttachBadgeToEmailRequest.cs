using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Models;

public class AttachBadgeToEmailRequest
{
    public string email { get; init; }
    public BadgeCode badgeCode { get; init; }
    public DateTime attachDate { get; init; }
}