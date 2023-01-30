using FluentValidation;
using Moq;
using VolumeVaultInfra.Controllers;
using VolumeVaultInfra.Exceptions;
using VolumeVaultInfra.Models.User;
using VolumeVaultInfra.Repositories;
using VolumeVaultInfra.Services.Jwt;
using VolumeVaultInfra.Validators;

namespace VolumeVaultInfra.Test.ControllersTests;

public class UserControllerExceptionsTest
{
    private Mock<IUserRepository> _userRepositoryMock { get; } = new();
    private UserController _userController { get; }
    
    public UserControllerExceptionsTest()
    {
        const string fakeSymetricKeyTest = "ce6b2e594abd903a1a12300f4604832d6ce905eb4b72f7ed71fe70e25c1e152c";
        JwtService jwtService = new(fakeSymetricKeyTest);
        IValidator<UserWriteModel> validator = new UserWriteModelValidator();
        
        _userController = new(_userRepositoryMock.Object, jwtService, validator);
    }

    [Fact]
    public async Task SignExistingUserTest()
    {
        UserWriteModel testUser = new()
        {
            username = "test",
            email = "test@test.com",
            password = "test1234"
        };
        _userRepositoryMock.Setup(ex => ex
                .SearchUserByUsernameOrEmail(testUser.username, testUser.email))
            .ReturnsAsync(new UserModel
            {
                id = 1,
                username = testUser.username,
                email = testUser.email,
                password = testUser.password
            });

        await Assert.ThrowsAsync<UserAlreadyExistException>(() => _userController.SigninUser(testUser));
    }
    
    [Fact]
    public void LoginNonExistingUserTest()
    {
        UserLoginRequestModel loginRequest = new()
        {
            username = "test",
            password = "test1234"
        };

        Assert.ThrowsAsync<UsernameIsNotRegisteredException>(() => _userController.LoginUser(loginRequest));
    }
    
    [Fact]
    public void LoginCredentialsNotMatchTest()
    {
        UserLoginRequestModel loginRequest = new()
        {
            username = "test",
            password = "test12345" //Wrong password
        };
        _userRepositoryMock.Setup(ex => 
                ex.GetUserByUsername(loginRequest.username))
            .ReturnsAsync(new UserModel
            {
                id = 1,
                username = "test",
                email = "test@test.com",
                password = "0+Yf74CcualNvW/7BnpJW6pFcivVb4Mc6/ye2qETuLqZsw9m6jENtOL/QBjAiKUQDIIYMzLXs8IbH2fBCw8bKw=="
            });
        
        Assert.ThrowsAsync<InvalidUserCredentialsException>(() => _userController.LoginUser(loginRequest));
    }
}