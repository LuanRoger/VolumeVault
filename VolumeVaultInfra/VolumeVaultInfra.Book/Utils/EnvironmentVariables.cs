

// ReSharper disable MemberCanBePrivate.Global

namespace VolumeVaultInfra.Book.Utils;

public static class EnvironmentVariables
{
    public static string? GetApiKey() => Environment
        .GetEnvironmentVariable(EnvVariableConsts.API_KEY);
    public static string? GetEnvironmentName() => Environment
        .GetEnvironmentVariable(EnvVariableConsts.ASPNETCORE_ENVIRONMENT);
    public static string? GetMySqlConnectionString() => Environment
        .GetEnvironmentVariable(EnvVariableConsts.MY_SQL_CONNECTION_STRING);
}
