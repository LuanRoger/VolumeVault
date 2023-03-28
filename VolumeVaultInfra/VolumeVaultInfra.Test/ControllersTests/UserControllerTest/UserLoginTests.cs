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

public class UserLoginTests
{
    private Mock<IUserRepository> _userRepositoryMock { get; } = new();
    private Mock<IUserControllerMetrics> _userControllerMetricsMock { get; } = new();
    private Mock<ILogger> _logger { get; } = new();
    private UserController _userController { get; }

    public UserLoginTests()
    {
        const string fakeSymetricKeyTest = "ce6b2e594abd903a1a12300f4604832d6ce905eb4b72f7ed71fe70e25c1e152c";
        JwtService jwtService = new(fakeSymetricKeyTest);
        IValidator<UserWriteModel> validator = new UserWriteModelValidator();
        
        _userController = new(_userRepositoryMock.Object, jwtService, _userControllerMetricsMock.Object,
            validator, _logger.Object);
    }
    
    [Fact]
    public async void LoginValidUserTest()
    {
        UserLoginRequestModel loginRequest = UserFakeModels.loginRequestTestDumy;
        UserModel user = UserFakeModels.userTestDumy;
        
        _userRepositoryMock.Setup(ex => 
                ex.GetUserByUsername(It.IsAny<string>()))
            .ReturnsAsync(user);
        
        string jwt = await _userController.LoginUser(loginRequest);
        
        Assert.NotEmpty(jwt);
        Assert.Matches(TestConts.JWT_VALID_REGEX, jwt);
    }
}