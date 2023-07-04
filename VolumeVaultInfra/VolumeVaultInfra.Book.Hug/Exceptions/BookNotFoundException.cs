namespace VolumeVaultInfra.Book.Hug.Exceptions;

public class BookNotFoundException : Exception
{
    private const string MESSAGE = "The ID {0} is not referred to any registered book.";

    public BookNotFoundException(string id) : base(string.Format(MESSAGE, id)) { }
    
}