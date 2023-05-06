namespace VolumeVaultInfra.Book.Repositories;

public interface IStatsRepository
{
    public Task<int> GetUserBooksCount(string userId);
}