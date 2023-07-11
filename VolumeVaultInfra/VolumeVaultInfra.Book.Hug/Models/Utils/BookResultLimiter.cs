using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Models.Utils;

public class BookResultLimiter
{
    public List<string>? genres { get; init; }
    public BookFormat? bookFormat { get; init; }
}