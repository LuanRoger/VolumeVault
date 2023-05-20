namespace VolumeVaultInfra.Book.Search.Utils.EnviromentVars;

internal static class EnvironmentVariables
{
    internal static string? GetApiKey() =>
        Environment.GetEnvironmentVariable(EnvVariablesConsts.SEARCH_API_KEY);
    internal static string? GetMeiliSearchHost() =>
        Environment.GetEnvironmentVariable(EnvVariablesConsts.MEILISEARCH_HOST);
    internal static string? GetMeiliseachMasterKey() =>
        Environment.GetEnvironmentVariable(EnvVariablesConsts.MEILISEARCH_MASTER_KEY);
}