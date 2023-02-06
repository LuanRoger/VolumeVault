namespace VolumeVaultInfra.Utils;

public static class EnvironmentsVariables
{
    public static string? GetSymmetricKey() => Environment
        .GetEnvironmentVariable(EnvVariableConsts.JWT_SYMMETRIC_KEY);
    public static string? GetEnvironmentName() => Environment
        .GetEnvironmentVariable(EnvVariableConsts.ASPNETCORE_ENVIRONMENT);
    public static string? GetPostgresHost() => Environment
        .GetEnvironmentVariable(EnvVariableConsts.POSTGRES_HOST);
    public static string? GetPostgresPort() => Environment
        .GetEnvironmentVariable(EnvVariableConsts.POSTGRES_PORT);
    public static string? GetDefaultPostgresDbName() => Environment
        .GetEnvironmentVariable(EnvVariableConsts.DEFAULT_POSTGRES_DB_NAME);
    public static string? GetVvPostgresUser() => Environment
        .GetEnvironmentVariable(EnvVariableConsts.VV_POSTGRES_USER);
    public static string? GetVvPosgresPassword() => Environment
        .GetEnvironmentVariable(EnvVariableConsts.VV_POSTGRES_PASSWORD);
}
