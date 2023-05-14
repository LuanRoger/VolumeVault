using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Repositories;
using ILogger = Serilog.ILogger;

namespace VolumeVaultInfra.Book.Hug.Controller;

public class StatsController : IStatsController
{
    private IStatsRepository statsRepository { get; }
    private IUserIdentifierRepository userIdentifierRepository { get; }
    private ILogger logger { get; }

    public StatsController(
        IStatsRepository statsRepository,
        IUserIdentifierRepository userIdentifierRepository,
        ILogger logger)
    {
        this.logger = logger;
        this.userIdentifierRepository = userIdentifierRepository;
        this.statsRepository = statsRepository;
    }
    
    public async Task<BooksStatsReadModel> GetUserBooksStats(string userId)
    {
        UserIdentifier user = await userIdentifierRepository.EnsureInMirror(new() 
            { userIdentifier = userId });
        int booksCount = await statsRepository.GetUserBooksCount(user);
        logger.Information("Getting book count from user ID[{UserId}]...", userId);

        return new()
        {
            count = booksCount
        };
    }
}