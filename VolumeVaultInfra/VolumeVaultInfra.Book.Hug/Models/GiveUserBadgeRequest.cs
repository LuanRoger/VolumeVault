using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Models;

public class GiveUserBadgeRequest
{
    public string userId { get; set; }
    public BadgeCode badgeCode { get; set; }
    public DateTime recivedAt { get; set; }
}