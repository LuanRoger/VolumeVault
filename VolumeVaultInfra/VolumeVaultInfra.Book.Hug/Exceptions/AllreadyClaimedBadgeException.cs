using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Exceptions;

public class AllreadyClaimedBadgeException : Exception
{
    private const string MESSAGE = "Badge BadgeCode[{0}] is allready claimed by User[{1}]";

    public AllreadyClaimedBadgeException(BadgeCode badgeCode, string userIdentifier)
        : base(string.Format(MESSAGE, badgeCode, userIdentifier)) { }
}