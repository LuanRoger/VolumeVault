using Moq;
using Serilog;
using VolumeVaultInfra.Book.Controllers;
using VolumeVaultInfra.Book.Models.Stats;
using VolumeVaultInfra.Book.Models.User;
using VolumeVaultInfra.Book.Repositories;
using VolumeVaultInfra.Book.Test.ControllersTests.UserControllerTest;

namespace VolumeVaultInfra.Test.ControllersTests;

public class StatsControllerTests
{
    private Mock<IStatsRepository> statsRepository { get; } = new();
    private Mock<ILogger> logger { get; } = new();
    
    private StatsController statsController { get; }

    public StatsControllerTests()
    {
        statsController = new(statsRepository.Object, logger.Object);
    }
    
    [Fact]
    public async void GetUserBookCount()
    {
        UserModel user = UserFakeModels.userTestDumy;
        const int booksCount = 10;
        
        statsRepository.Setup(ex => ex.GetUserBooksCount(user.id))
            .ReturnsAsync(booksCount);
        
        BooksStatsReadModel stats = await statsController.GetUserBooksStats(user.id);
        
        Assert.Equal(booksCount, stats.count);
    }
}