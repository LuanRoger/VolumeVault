using FluentValidation;
using Moq;
using VolumeVaultInfra.Controllers;
using VolumeVaultInfra.Models.User;
using VolumeVaultInfra.Repositories;
using VolumeVaultInfra.Services.Jwt;
using VolumeVaultInfra.Validators;

namespace VolumeVaultInfra.Test.ControllersTests;

public class UserControllerTest
{
    private Mock<IUserRepository> _userRepositoryMock { get; } = new();
    private UserController _userController { get; }

    public UserControllerTest()
    {
        const string fakeSymetricKeyTest = "ce6b2e594abd903a1a12300f4604832d6ce905eb4b72f7ed71fe70e25c1e152c";
        JwtService jwtService = new(fakeSymetricKeyTest);
        IValidator<UserWriteModel> validator = new UserWriteModelValidator();
        
        _userController = new(_userRepositoryMock.Object, jwtService, validator);
    }
    
    private static UserModel userTestDumy => new()
    {
        id = 1,
        username = "test",
        email = "test@test.com",
        password = "0+Yf74CcualNvW/7BnpJW6pFcivVb4Mc6/ye2qETuLqZsw9m6jENtOL/QBjAiKUQDIIYMzLXs8IbH2fBCw8bKw=="
    };
    
    private static UserWriteModel userWriteTestDumy => new()
    {
        username = "test",
        email = "test@test.com",
        password = "test1234"
    };
    private static UserLoginRequestModel loginRequestTestDumy => new()
    {
        username = "test",
        password = "test1234"
    };
    
    [Fact]
    public async void SignValidUserTest()
    {
        UserWriteModel userWrite = userWriteTestDumy;
        
        _userRepositoryMock.Setup(ex => ex
                .AddUser(It.IsAny<UserModel>()))
            .ReturnsAsync(new UserModel
            {
                id = 1,
                username = userWrite.username,
                email = userWrite.email,
                password = userWrite.password
            });
        
        string jwt = await _userController.SigninUser(userWrite);
        
        Assert.NotEmpty(jwt);
        Assert.Matches(TestConts.JWT_VALID_REGEX, jwt);
    }

    [Fact]
    public async void LoginValidUserTest()
    {
        UserLoginRequestModel loginRequest = loginRequestTestDumy;
        UserModel user = userTestDumy;
        
        _userRepositoryMock.Setup(ex => 
                ex.GetUserByUsername(It.IsAny<string>()))
            .ReturnsAsync(user);
        
        string jwt = await _userController.LoginUser(loginRequest);
        
        Assert.NotEmpty(jwt);
        Assert.Matches(TestConts.JWT_VALID_REGEX, jwt);
    }
}