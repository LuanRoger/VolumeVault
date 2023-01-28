using VolumeVaultInfra.Models.User;

namespace VolumeVaultInfra.Controllers;

public interface IUserController
{
    public Task<string> SigninUser(UserWriteModel userWrite);
    public Task<string> LoginUser(UserLoginRequestModel loginRequest);
}