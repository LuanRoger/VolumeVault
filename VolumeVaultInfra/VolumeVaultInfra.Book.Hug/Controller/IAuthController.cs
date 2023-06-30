using VolumeVaultInfra.Book.Hug.Models;

namespace VolumeVaultInfra.Book.Hug.Controller;

public interface IAuthController
{
    public Task<UserInfo> GetUserFromAuthWEmail(string email);
    public Task<UserInfo> GetUserFromAuthWIdentifier(string userId);
}