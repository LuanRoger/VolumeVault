using VolumeVaultInfra.Models.User;

namespace VolumeVaultInfra.Repositories;

public interface IUserRepository
{
    public Task<UserModel> AddUser(UserModel user);
    
    public Task<UserModel?> GetUserById(int id);
    public Task<UserModel?> GetUserByUsername(string username);
    
    public Task<UserModel?> SearchUserByUsernameOrEmail(string username, string email);
    
    public Task Flush();
}