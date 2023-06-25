using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Models;

public class BadgeReadModel
{
    public int count { get; init; }
    public IReadOnlyList<BadgeCodes> badgeCodes { get; init; }
}