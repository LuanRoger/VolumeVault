using VolumeVaultInfra.Extensions;

namespace VolumeVaultInfra.Exceptions;

public class NotValidUserWriteException : Exception
{
    private const string MESSAGE = "The user informations is not valid: [{0}]";

    public NotValidUserWriteException(IEnumerable<string> errorMessages) : 
        base(string.Format(MESSAGE, errorMessages.ToSeparatedString())) { }
}