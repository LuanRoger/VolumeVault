using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Book.Hug.Contexts;
using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public class UserIdentifierRepository : IUserIdentifierRepository
{
    private DatabaseContext dbIdentity { get; }

    public UserIdentifierRepository(DatabaseContext dbIdentity)
    {
        this.dbIdentity = dbIdentity;
    }
    
    public async Task<UserIdentifier> EnsureInMirror(UserIdentifier userIdentifier)
    {
        UserIdentifier? user = await dbIdentity.userIdentifiers
            .FirstOrDefaultAsync(identifier => 
                identifier.userIdentifier == userIdentifier.userIdentifier);
        user ??= (await dbIdentity.userIdentifiers.AddAsync(userIdentifier)).Entity;
        
        return user;
    }
}