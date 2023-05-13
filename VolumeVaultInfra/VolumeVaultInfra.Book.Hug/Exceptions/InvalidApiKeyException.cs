namespace VolumeVaultInfra.Book.Hug.Exceptions;

public class InvalidApiKeyException : Exception
{
    internal const string MESSAGE = "The x-api-key was not provided or not setted on enviroment variables";

    public InvalidApiKeyException() : base(MESSAGE) { }
}