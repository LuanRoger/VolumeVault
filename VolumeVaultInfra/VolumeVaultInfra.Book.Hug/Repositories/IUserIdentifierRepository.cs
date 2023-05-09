using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public interface IUserIdentifierRepository
{
    public Task<UserIdentifier> EnsureInMirror(UserIdentifier userIdentifier);
}