namespace VolumeVaultInfra.Book.Hug.Utils;

public static class EnvironmentVariables
{
    public static string? GetMySQLConnectionString() =>
        Environment.GetEnvironmentVariable(EnvVariablesConsts.MY_SQL_CONNECTION_STRING);
    public static string? GetMeiliseachMasterKey() =>
        Environment.GetEnvironmentVariable(EnvVariablesConsts.MEILISEARCH_MASTER_KEY);
    public static string? GetMeiliSearchHost() =>
        Environment.GetEnvironmentVariable(EnvVariablesConsts.MEILISEARCH_HOST);
}