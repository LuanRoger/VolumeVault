namespace VolumeVaultInfra.Exceptions;

public class NotOwnerBookException : Exception
{
    private const string MESSAGE = "The book {0} is not owned by {1}";

    public NotOwnerBookException(string bookName, string username) : 
        base(string.Format(MESSAGE, bookName, username)) { }
}