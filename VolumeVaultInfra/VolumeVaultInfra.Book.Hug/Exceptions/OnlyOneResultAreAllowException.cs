namespace VolumeVaultInfra.Book.Hug.Exceptions;

public class OnlyOneResultAreAllowException : Exception
{
    private const string MESSAGE = "Only one result of {0} are allow";

    public OnlyOneResultAreAllowException(string resultName) : 
        base(string.Format(MESSAGE, resultName)) { }
}