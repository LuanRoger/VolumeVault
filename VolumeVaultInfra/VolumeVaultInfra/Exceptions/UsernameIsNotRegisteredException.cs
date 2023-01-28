namespace VolumeVaultInfra.Exceptions;

public class UsernameIsNotRegisteredException : Exception
{
    private const string MESSAGE = "The username {0} is not registered";

    public UsernameIsNotRegisteredException(string username) : base(string.Format(MESSAGE, username)) { }
}