using AutoMapper;
using FirebaseAdmin.Auth;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using UserIdentifier = VolumeVaultInfra.Book.Hug.Models.Base.UserIdentifier;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public class AuthRepository : IAuthRepository
{
    private IMapper mapper { get; }

    public AuthRepository(IMapper mapper)
    {
        this.mapper = mapper;
    }
    
    public async Task<UserInfo?> GetUser(UserIdentifier userId)
    {
        UserRecord userRecord;
        try
        {
            userRecord = await FirebaseAuth.DefaultInstance.GetUserAsync(userId.userIdentifier);
        }
        catch(Exception) { return null; }

        UserInfo mappedUser = mapper.Map<UserRecord, UserInfo>(userRecord);
        return mappedUser;
    }

    public async Task<UserInfo?> GetUserByEmail(EmailUserIdentifier userEmailIdentifier)
    {
        UserRecord userRecord;
        try
        {
            userRecord = await FirebaseAuth.DefaultInstance.GetUserByEmailAsync(userEmailIdentifier.email);
        }
        catch(Exception) { return null; }
        
        UserInfo mappedUser = mapper.Map<UserRecord, UserInfo>(userRecord);
        return mappedUser;
    }
}