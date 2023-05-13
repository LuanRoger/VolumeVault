namespace VolumeVaultInfra.Book.Hug.Exceptions;

public class UserDoesNotExistsException : Exception
{
    private const string MESSAGE = "The user ID[{0}] is not mirrored on the book database";

    public UserDoesNotExistsException(string userId) : 
        base(string.Format(MESSAGE, userId)) {}
}