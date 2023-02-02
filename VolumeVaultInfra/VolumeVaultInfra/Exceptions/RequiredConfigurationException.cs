namespace VolumeVaultInfra.Exceptions;

public class RequiredConfigurationException : Exception
{
    private const string MESSAGE = "The configuration section {0} can't be null or empty";

    public RequiredConfigurationException(string configSection) : 
        base(string.Format(MESSAGE, configSection)) { }
}