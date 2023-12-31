namespace VolumeVaultInfra.Book.Hug.Exceptions;

public class NotModifiedBookException : Exception
{
    private const string MESSAGE = "Book ID[{0}] has not been modified";

    public NotModifiedBookException(string bookId) : 
        base(string.Format(MESSAGE, bookId)) { }
}