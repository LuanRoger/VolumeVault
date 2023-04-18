namespace VolumeVaultInfra.Repositories;

public interface IStatsRepository
{
    public Task<int> GetUserBooksCount(int userId);
}