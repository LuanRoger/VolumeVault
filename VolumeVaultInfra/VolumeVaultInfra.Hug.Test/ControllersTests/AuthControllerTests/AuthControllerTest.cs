using Moq;
using Serilog;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Repositories;
using VolumeVaultInfra.Hug.Test.ControllersTests.AuthControllerTests.FakeData;

namespace VolumeVaultInfra.Hug.Test.ControllersTests.AuthControllerTests;

public class AuthControllerTest
{
    private AuthController authController { get; }
    private Mock<ILogger> logger { get; } = new();
    private Mock<IAuthRepository> authRepository { get; } = new();
    private Mock<IUserIdentifierRepository> userIdentifierRepository { get; } = new();
    private Mock<IEmailUserIdentifierRepository> emailUserIdentifierRepository { get; } = new();

    public AuthControllerTest()
    {
        authController = new(logger.Object, authRepository.Object, userIdentifierRepository.Object, emailUserIdentifierRepository.Object);
    }
    
    [Fact]
    public async void GetUserFromAuthIdentifierTest()
    {
        const string userIdentifier = "0";
        UserIdentifier returnedUserIdentifier = AuthFakeData.fakeUserIdentifier;
        UserInfo returnedUserInfo = AuthFakeData.fakeUserInfo;
        
        userIdentifierRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(returnedUserIdentifier);
        authRepository.Setup(ex => ex.GetUser(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(returnedUserInfo);
        
        UserInfo userInfo = await authController.GetUserFromAuthWIdentifier(userIdentifier);
        
        Assert.Equal(returnedUserInfo.uid, userInfo.uid);
        Assert.Equal(returnedUserInfo.email, userInfo.email);
        Assert.Equal(returnedUserInfo.displayName, userInfo.displayName);
        Assert.Equal(returnedUserInfo.disabled, userInfo.disabled);
        Assert.Equal(returnedUserInfo.verifiedEmail, userInfo.verifiedEmail);
    }
    
    [Fact]
    public async void GetUserFromAuthEmailTest()
    {
        const string userEmail = "test@test.com";
        EmailUserIdentifier returnedUserIdentifier = AuthFakeData.fakeEmailUserIdentifierNoUser;
        UserInfo returnedUserInfo = AuthFakeData.fakeUserInfo;
        
        emailUserIdentifierRepository.Setup(ex => ex.EnsureEmailExists(It.IsAny<EmailUserIdentifier>()))
            .ReturnsAsync(returnedUserIdentifier);
        authRepository.Setup(ex => ex.GetUserByEmail(It.IsAny<EmailUserIdentifier>()))
            .ReturnsAsync(returnedUserInfo);
        
        UserInfo userInfo = await authController.GetUserFromAuthWEmail(userEmail);
        
        Assert.Equal(returnedUserInfo.uid, userInfo.uid);
        Assert.Equal(returnedUserInfo.email, userInfo.email);
        Assert.Equal(returnedUserInfo.displayName, userInfo.displayName);
        Assert.Equal(returnedUserInfo.disabled, userInfo.disabled);
        Assert.Equal(returnedUserInfo.verifiedEmail, userInfo.verifiedEmail);
    }
}