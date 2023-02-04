using Microsoft.Extensions.Diagnostics.HealthChecks;

namespace VolumeVaultInfra.Services;

public sealed class HealthCheckService : IHealthCheck
{
    public Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken cancellationToken = new CancellationToken())
    {
        return Task.FromResult(HealthCheckResult.Healthy());
    }
}