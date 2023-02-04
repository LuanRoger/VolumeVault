using Prometheus;

namespace VolumeVaultInfra.Services.Metrics;

public interface IUserControllerMetrics
{
    public void IncreaseRegisteredUsers();
    public void IncreaseNumberLogins();
    public Histogram RegisterUserRegisterTime();
}