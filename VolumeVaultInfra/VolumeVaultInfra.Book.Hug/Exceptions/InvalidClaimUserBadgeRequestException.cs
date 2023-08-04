using VolumeVaultInfra.Book.Hug.Extensions;

namespace VolumeVaultInfra.Book.Hug.Exceptions;

public class InvalidClaimUserBadgeRequestException : Exception
{
    private const string MESSAGE = "The claim user badge request is invalid: [{0}]";
    
    public InvalidClaimUserBadgeRequestException(IEnumerable<string> errorMessages) : 
        base(string.Format(MESSAGE, errorMessages.ToSeparatedString())) { }
}