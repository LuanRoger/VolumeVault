namespace VolumeVaultInfra.Exceptions;

public class UserIdIsNotRegisteredException : Exception
{
    private const string MESSAGE = "The ID[{0}] is not registered";
    
    public UserIdIsNotRegisteredException(int userId) : base(string.Format(MESSAGE, userId)) {}
}