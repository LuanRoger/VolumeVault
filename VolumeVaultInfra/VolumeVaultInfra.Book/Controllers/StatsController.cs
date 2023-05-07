using VolumeVaultInfra.Book.Models.Stats;
using VolumeVaultInfra.Book.Repositories;
using ILogger = Serilog.ILogger;

namespace VolumeVaultInfra.Book.Controllers;

public class StatsController : IStatsController
{
    private IStatsRepository statsRepository { get; }
    private ILogger logger { get; }

    public StatsController(
        IStatsRepository statsRepository,
        ILogger logger)
    {
        this.logger = logger;
        this.statsRepository = statsRepository;
    }
    
    public async Task<BooksStatsReadModel> GetUserBooksStats(string userId)
    {
        int booksCount = await statsRepository.GetUserBooksCount(userId);
        logger.Information("Getting book count from user ID[{0}]...", userId);

        return new()
        {
            count = booksCount
        };
    }
}