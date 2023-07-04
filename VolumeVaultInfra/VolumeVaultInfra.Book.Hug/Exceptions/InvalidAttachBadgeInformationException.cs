using VolumeVaultInfra.Book.Hug.Extensions;

namespace VolumeVaultInfra.Book.Hug.Exceptions;

public class InvalidAttachBadgeInformationException : Exception
{
    private const string MESSAGE = "The attachment badge information is not valid: [{0}]";

    public InvalidAttachBadgeInformationException(IEnumerable<string> errorMessages) : 
        base(string.Format(MESSAGE, errorMessages.ToSeparatedString())) { }
}