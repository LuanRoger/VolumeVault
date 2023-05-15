using Grpc.Core;
using Grpc.Core.Interceptors;
using VolumeVaultInfra.Book.Search.Exceptions;
using VolumeVaultInfra.Book.Search.Utils;
using VolumeVaultInfra.Book.Search.Utils.EnviromentVars;
using ILogger = Serilog.ILogger;

namespace VolumeVaultInfra.Book.Search.Interceptors;

public class ApiKeyInterceptor : Interceptor
{
    private ILogger logger { get; }

    public ApiKeyInterceptor(Serilog.ILogger logger)
    {
        this.logger = logger;
    }
    
    private static bool HandleApiKey(ServerCallContext context)
    {
        string? metadataApiKey = context.RequestHeaders.GetValue(MetadataVariablesConsts.METADATA_API_KEY);
        string? envApiKey = EnvironmentVariables.GetApiKey();
        
        bool provededApiKeys = !string.IsNullOrEmpty(metadataApiKey) && !string.IsNullOrEmpty(envApiKey);

        return provededApiKeys && envApiKey!.Equals(metadataApiKey);
    }
    
    public override async Task<TResponse> UnaryServerHandler<TRequest, TResponse>(TRequest request, 
        ServerCallContext context,
        UnaryServerMethod<TRequest, TResponse> continuation)
    {
        bool apiKeyIsValid = HandleApiKey(context);
        if(apiKeyIsValid)
            return await continuation(request, context);
        
        InvalidApiKeyException exception = new();
        logger.Error(exception, InvalidApiKeyException.MESSAGE);
            
        throw new RpcException(new(StatusCode.Unauthenticated, exception.Message));
    }

    public override async Task DuplexStreamingServerHandler<TRequest, TResponse>(IAsyncStreamReader<TRequest> requestStream,
        IServerStreamWriter<TResponse> responseStream, ServerCallContext context, DuplexStreamingServerMethod<TRequest, TResponse> continuation)
    {
        bool apiKeyIsValid = HandleApiKey(context);
        if(apiKeyIsValid)
            await continuation(requestStream, responseStream, context);
        else
        {
            InvalidApiKeyException exception = new();
            logger.Error(exception, InvalidApiKeyException.MESSAGE);
            
            throw new RpcException(new(StatusCode.Unauthenticated, exception.Message));
        }
    }
}