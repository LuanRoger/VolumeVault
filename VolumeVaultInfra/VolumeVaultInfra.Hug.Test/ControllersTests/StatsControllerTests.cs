using Moq;
using Serilog;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Repositories;

namespace VolumeVaultInfra.Hug.Test.ControllersTests;

public class StatsControllerTests
{
    private Mock<IStatsRepository> statsRepository { get; } = new();
    private Mock<IUserIdentifierRepository> userRepository { get; } = new();
    private Mock<ILogger> logger { get; } = new();
    
    private StatsController statsController { get; }

    public StatsControllerTests()
    {
        statsController = new(statsRepository.Object, userRepository.Object, logger.Object);
    }
    
    [Fact]
    public async void GetUserBookCount()
    {
        const string userIdentifier = "1";
        const int booksCount = 10;
        
        statsRepository.Setup(ex => ex.GetUserBooksCount(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(booksCount);
        
        BooksStatsReadModel stats = await statsController.GetUserBooksStats(userIdentifier);
        
        Assert.Equal(booksCount, stats.count);
    }
}