using FluentValidation;
using Moq;
using Serilog;
using VolumeVaultInfra.Controllers;
using VolumeVaultInfra.Models.User;
using VolumeVaultInfra.Repositories;
using VolumeVaultInfra.Services.Jwt;
using VolumeVaultInfra.Services.Metrics;
using VolumeVaultInfra.Validators;

namespace VolumeVaultInfra.Test.ControllersTests.UserControllerTest;

public class GetUserInfoTest
{
    private Mock<IUserRepository> userRepository { get; } = new();
    private Mock<IUserControllerMetrics> metrics { get; } = new();
    private Mock<ILogger> logger { get; } = new();
    
    private UserController controller { get; }

    public GetUserInfoTest()
    {
        const string fakeSymetricKeyTest = "ce6b2e594abd903a1a12300f4604832d6ce905eb4b72f7ed71fe70e25c1e152c";
        JwtService jwtService = new(fakeSymetricKeyTest);
        IValidator<UserWriteModel> validator = new UserWriteModelValidator();
        
        controller = new(userRepository.Object, jwtService, metrics.Object,
            validator, logger.Object);
    }
    
    [Fact]
    public async void GetValidUserInfoTest()
    {
        UserModel dumyUser = UserFakeModels.userTestDumy;
        
        userRepository.Setup(ex => 
                ex.GetUserById(dumyUser.id))
            .ReturnsAsync(dumyUser);
        
        UserReadModel user = await controller.GetUserInfo(dumyUser.id);
        
        Assert.Equal(dumyUser.id, user.id);
        Assert.Equal(dumyUser.username, user.username);
        Assert.Equal(dumyUser.email, user.email);
    }
}