using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public interface IStatsRepository
{
    public Task<int> GetUserBooksCount(UserIdentifier user);
}