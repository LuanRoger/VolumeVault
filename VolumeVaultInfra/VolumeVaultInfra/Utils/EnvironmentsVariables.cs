namespace VolumeVaultInfra.Utils;

public static class EnvironmentsVariables
{
    public static string? GetSymetricKey() => Environment
        .GetEnvironmentVariable(EnvVariableConsts.JWT_SYMETRIC_KEY);
}
