using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public interface IAuthRepository
{
    public Task<UserInfo?> GetUser(UserIdentifier userId);
    public Task<UserInfo?> GetUserByEmail(EmailUserIdentifier userEmailIdentifier);
}