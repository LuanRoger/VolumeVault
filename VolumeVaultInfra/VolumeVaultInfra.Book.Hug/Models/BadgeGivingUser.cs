using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Models;

public class BadgeGivingUser
{
    public BadgeCode badgeCode { get; init; }
    public DateTime recivedAt { get; set; }
}