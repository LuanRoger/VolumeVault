using VolumeVaultInfra.Book.Models.Stats;

namespace VolumeVaultInfra.Book.Controllers;

public interface IStatsController
{
    public Task<BooksStatsReadModel> GetUserBooksStats(string userId);
}