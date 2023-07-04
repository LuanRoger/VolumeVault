namespace VolumeVaultInfra.Book.Hug.Exceptions;

public class UserEmailDoesNotExitsException : Exception
{
    public const string MESSAGE = "The user with Email[{0}] does not exists";

    public UserEmailDoesNotExitsException(string email) : 
        base(string.Format(MESSAGE, email)) {}
}