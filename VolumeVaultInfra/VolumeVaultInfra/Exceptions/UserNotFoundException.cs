namespace VolumeVaultInfra.Exceptions;

public class UserNotFoundException : Exception
{
    private const string MESSAGE = "The ID {0} is not referred to any registered user.";

    public UserNotFoundException(int id) : base(string.Format(MESSAGE, id)) { }
}