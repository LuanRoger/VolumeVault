using VolumeVaultInfra.Models.Stats;

namespace VolumeVaultInfra.Controllers;

public interface IStatsController
{
    public Task<BooksStatsReadModel> GetUserBooksStats(string userId);
}