namespace VolumeVaultInfra.Exceptions;

public class InvalidUserCredentialsException : Exception
{
    private const string MESSAGE = "The credentials of user {0} is invalid.";

    public InvalidUserCredentialsException(string username) : base(string.Format(MESSAGE, username)) { }
}