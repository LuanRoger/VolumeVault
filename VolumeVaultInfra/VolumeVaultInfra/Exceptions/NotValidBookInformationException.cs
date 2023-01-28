using VolumeVaultInfra.Extensions;

namespace VolumeVaultInfra.Exceptions;

public class NotValidBookInformationException : Exception
{
    private const string MESSAGE = "The book informations is not valid: [{0}]";

    public NotValidBookInformationException(IEnumerable<string> errorMessages) : 
        base(string.Format(MESSAGE, errorMessages.ToSeparatedString())) { }
}