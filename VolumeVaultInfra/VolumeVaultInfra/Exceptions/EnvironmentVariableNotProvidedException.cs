namespace VolumeVaultInfra.Exceptions;

public class EnvironmentVariableNotProvidedException : Exception
{
    private const string MESSAGE = "The environment variable {0} must be provided";

    public EnvironmentVariableNotProvidedException(string variableName) : 
        base(string.Format(MESSAGE, variableName)) { }
}