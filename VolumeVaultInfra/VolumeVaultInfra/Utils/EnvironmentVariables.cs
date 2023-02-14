using VolumeVaultInfra.Exceptions;

// ReSharper disable MemberCanBePrivate.Global

namespace VolumeVaultInfra.Utils;

public static class EnvironmentVariables
{
    public static string? GetApiKey() => Environment
        .GetEnvironmentVariable(EnvVariableConsts.API_KEY);
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
    public static string FormatVvPostgresConnectionString(string baseString)
    {
        string? postgresUser = GetVvPostgresUser();
        string? postgresPassword = GetVvPosgresPassword();
        string? postgresHost = GetPostgresHost();
        string? postgresPort = GetPostgresPort();
        string? dbName = GetDefaultPostgresDbName();

        if(string.IsNullOrEmpty(postgresUser))
            throw new EnvironmentVariableNotProvidedException(EnvVariableConsts.VV_POSTGRES_USER);
        if(string.IsNullOrEmpty(postgresPassword))
            throw new EnvironmentVariableNotProvidedException(EnvVariableConsts.VV_POSTGRES_PASSWORD);
        if(string.IsNullOrEmpty(postgresHost))
            throw new EnvironmentVariableNotProvidedException(EnvVariableConsts.POSTGRES_HOST);
        if(string.IsNullOrEmpty(postgresPort))
            throw new EnvironmentVariableNotProvidedException(EnvVariableConsts.POSTGRES_PORT);
        if(string.IsNullOrEmpty(dbName))
            throw new EnvironmentVariableNotProvidedException(EnvVariableConsts.DEFAULT_POSTGRES_DB_NAME);
        
        return string.Format(baseString, postgresUser, postgresPassword,
            postgresHost, postgresPort, dbName);
    }
    public static string? GetVvMongoUser() => 
        Environment.GetEnvironmentVariable(EnvVariableConsts.VV_MONGO_USER);
    public static string? GetVvMongoPassword() => 
        Environment.GetEnvironmentVariable(EnvVariableConsts.VV_MONGO_PASSWORD);
    public static string? GetVvMongoHost() => Environment
        .GetEnvironmentVariable(EnvVariableConsts.VV_MONGO_HOST);
    public static string? GetVvMongoPort() => Environment
        .GetEnvironmentVariable(EnvVariableConsts.VV_MONGO_PORT);
    public static string? GetVvMongoDbName() => 
        Environment.GetEnvironmentVariable(EnvVariableConsts.VV_MONGO_DB_NAME);
    public static string FormatVvMongoConnectionString(string baseString)
    {
        string? host = GetVvMongoHost();
        string? port = GetVvMongoPort();
        string? username = GetVvMongoUser();
        string? password = GetVvMongoPassword();

        if(string.IsNullOrEmpty(host))
            throw new EnvironmentVariableNotProvidedException(EnvVariableConsts.VV_MONGO_HOST);
        if(string.IsNullOrEmpty(port))
            throw new EnvironmentVariableNotProvidedException(EnvVariableConsts.VV_MONGO_PORT);
        if(string.IsNullOrEmpty(username))
            throw new EnvironmentVariableNotProvidedException(EnvVariableConsts.VV_MONGO_USER);
        if(string.IsNullOrEmpty(password))
            throw new EnvironmentVariableNotProvidedException(EnvVariableConsts.VV_MONGO_PASSWORD);
        
        return string.Format(baseString, username, password, host, port);
    }
}
