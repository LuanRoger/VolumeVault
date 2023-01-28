namespace VolumeVaultInfra.Exceptions;

public class UserAlreadyExistException : Exception
{
    private const string MESSAGE = "There is a user registreded with this username or email.";

    public UserAlreadyExistException() : base(MESSAGE) { }
}