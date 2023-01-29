using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Context;
using VolumeVaultInfra.Models.User;

namespace VolumeVaultInfra.Repositories;

public class UserRepository : IUserRepository
{
    private DatabaseBaseContext _userDb { get; }
    
    public UserRepository(DatabaseBaseContext userDb)
    {
        _userDb = userDb;
    }
    
    public async Task<UserModel> AddUser(UserModel user) => (await _userDb.users.AddAsync(user)).Entity;

    public async Task<UserModel?> GetUserById(int id) => await _userDb.users.FindAsync(id);
    public async Task<UserModel?> GetUserByUsername(string username) =>
        await _userDb.users
            .FirstOrDefaultAsync(user => user.username == username);
    public async Task<UserModel?> SearchUserByUsernameOrEmail(string username, string email) => 
        await _userDb.users.FirstOrDefaultAsync(user => user.username == username || user.email == email);
    
    public async Task Flush() => await _userDb.SaveChangesAsync();
}