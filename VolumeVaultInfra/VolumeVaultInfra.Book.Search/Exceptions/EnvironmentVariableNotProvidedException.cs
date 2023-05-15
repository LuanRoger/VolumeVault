namespace VolumeVaultInfra.Book.Search.Exceptions;

public class EnvironmentVariableNotProvidedException : Exception
{
    private const string MESSAGE = "The environment variable {0} must be provided or it's empty.";

    public EnvironmentVariableNotProvidedException(string variableName) : 
        base(string.Format(MESSAGE, variableName)) { }
}