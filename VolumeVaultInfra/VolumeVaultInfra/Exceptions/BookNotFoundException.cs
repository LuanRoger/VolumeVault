namespace VolumeVaultInfra.Exceptions;

public class BookNotFoundException : Exception
{
    private const string MESSAGE = "The ID {0} is not referred to any registered book.";

    public BookNotFoundException(int id) : base(string.Format(MESSAGE, id)) { }
    
}