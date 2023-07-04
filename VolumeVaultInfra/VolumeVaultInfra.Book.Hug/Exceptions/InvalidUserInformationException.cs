using VolumeVaultInfra.Book.Hug.Extensions;

namespace VolumeVaultInfra.Book.Hug.Exceptions;

public class InvalidUserInformationException : Exception
{
    private const string MESSAGE = "The user informations is not valid: [{0}]";
    
    public InvalidUserInformationException(IEnumerable<string> errorMessages) : 
        base(string.Format(MESSAGE, errorMessages.ToSeparatedString())) { }
}