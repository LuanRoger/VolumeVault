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
    
    [Fact]
    public async void SignValidUserTest()
    {
        UserWriteModel testUser = new()
        {
            username = "test",
            email = "test@test.com",
            password = "test1234"
        };
        
        _userRepositoryMock.Setup(ex => ex
                .AddUser(It.IsAny<UserModel>()))
            .ReturnsAsync(new UserModel
            {
                id = 1,
                username = testUser.username,
                email = testUser.email,
                password = testUser.password
            });
        
        string jwt = await _userController.SigninUser(testUser);
        
        Assert.NotEmpty(jwt);
        Assert.Matches(TestConts.JWT_VALID_REGEX, jwt);
    }

    [Fact]
    public async void LoginValidUserTest()
    {
        UserModel userInDb = new()
        {
            id = 1,
            username = "test",
            email = "test@test.com",
            password = "0+Yf74CcualNvW/7BnpJW6pFcivVb4Mc6/ye2qETuLqZsw9m6jENtOL/QBjAiKUQDIIYMzLXs8IbH2fBCw8bKw=="
        };
        UserLoginRequestModel loginRequest = new()
        {
            username = userInDb.username,
            password = "test1234"
        };
        
        _userRepositoryMock.Setup(ex => 
                ex.GetUserByUsername(userInDb.username))
            .ReturnsAsync(userInDb);
        
        string jwt = await _userController.LoginUser(loginRequest);
        
        Assert.NotEmpty(jwt);
        Assert.Matches(TestConts.JWT_VALID_REGEX, jwt);
    }
}