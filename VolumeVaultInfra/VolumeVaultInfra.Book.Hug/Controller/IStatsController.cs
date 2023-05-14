using VolumeVaultInfra.Book.Hug.Models;

namespace VolumeVaultInfra.Book.Hug.Controller;

public interface IStatsController
{
    public Task<BooksStatsReadModel> GetUserBooksStats(string userId);
}