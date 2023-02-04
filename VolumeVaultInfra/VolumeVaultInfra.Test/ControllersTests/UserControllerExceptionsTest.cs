using FluentValidation;
using Moq;
using Serilog;
using VolumeVaultInfra.Controllers;
using VolumeVaultInfra.Exceptions;
using VolumeVaultInfra.Models.User;
using VolumeVaultInfra.Repositories;
using VolumeVaultInfra.Services.Jwt;
using VolumeVaultInfra.Services.Metrics;
using VolumeVaultInfra.Validators;

namespace VolumeVaultInfra.Test.ControllersTests;

public class UserControllerExceptionsTest
{
    private Mock<IUserRepository> _userRepositoryMock { get; } = new();
    private Mock<IUserControllerMetrics> _userControllerMetricsMock { get; } = new();
    private Mock<ILogger> _logger { get; } = new();
    private UserController _userController { get; }
    
    public UserControllerExceptionsTest()
    {
        const string fakeSymetricKeyTest = "ce6b2e594abd903a1a12300f4604832d6ce905eb4b72f7ed71fe70e25c1e152c";
        JwtService jwtService = new(fakeSymetricKeyTest);
        IValidator<UserWriteModel> validator = new UserWriteModelValidator();
        
        _userController = new(_userRepositoryMock.Object, jwtService, _userControllerMetricsMock.Object,
            validator, _logger.Object);
    }
    
    private static UserWriteModel userTestDumy => new()
    {
        username = "test",
        email = "test@test.com",
        password = "test1234"
    };
    private static UserWriteModel invalidUserTestDumy => new()
    {
        username = "test",
        email = "test@test",
        password = "test123"
    };
    private static UserLoginRequestModel loginRequestTestDumy => new()
    {
        username = "test",
        password = "test1234"
    };
    
    [Fact]
    public async void SignInvalidUserTest()
    {
        UserWriteModel invalidUser = invalidUserTestDumy;
        
        await Assert.ThrowsAsync<NotValidUserWriteException>(() => 
            _userController.SigninUser(invalidUserTestDumy));
    }
    
    [Fact]
    public async Task SignExistingUserTest()
    {
        UserWriteModel user = userTestDumy;

        _userRepositoryMock.Setup(ex => ex
                .SearchUserByUsernameOrEmail(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync(new UserModel
            {
                id = 1,
                username = user.username,
                email = user.email,
                password = user.password
            });

        await Assert.ThrowsAsync<UserAlreadyExistException>(() => _userController.SigninUser(user));
    }
    
    [Fact]
    public async void LoginNonExistingUserTest()
    {
        UserLoginRequestModel loginRequest = loginRequestTestDumy;

        await Assert.ThrowsAsync<UsernameIsNotRegisteredException>(() => _userController.LoginUser(loginRequest));
    }
    
    [Fact]
    public async void LoginCredentialsNotMatchTest()
    {
        UserWriteModel user = userTestDumy;
        UserLoginRequestModel loginRequest = loginRequestTestDumy;
        loginRequest.password = "test12345"; //Wrong password

        _userRepositoryMock.Setup(ex => 
                ex.GetUserByUsername(loginRequest.username))
            .ReturnsAsync(new UserModel
            {
                id = 1,
                username = user.username,
                email = user.email,
                password = user.password
            });
        
        await Assert.ThrowsAsync<InvalidUserCredentialsException>(() => _userController.LoginUser(loginRequest));
    }
}