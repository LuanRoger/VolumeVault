using Prometheus;

namespace VolumeVaultInfra.Services.Metrics;

public class UserControllerMetrics : IUserControllerMetrics
{
    private static Counter registeredUsers => Prometheus.Metrics
        .CreateCounter("vvinfra_registered_users_total", "Number of registered users.");
    /*private Gauge _existingUsers = Prometheus.Metrics
        .CreateGauge("vvinfra_existing_users_total", "Number of users currently.");*/
    private static Counter numberOfLogins => Prometheus.Metrics
        .CreateCounter("vvinfra_logins_request_total", "Number of login requests.");
    
    public void IncreaseRegisteredUsers() => registeredUsers.Inc();
    public void IncreaseNumberLogins() => numberOfLogins.Inc();
    public Histogram RegisterUserRegisterTime() => Prometheus.Metrics
        .CreateHistogram("vvinfra_user_register_time", "User register time, including password hash");
}