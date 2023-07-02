using Moq;
using Serilog;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Repositories;
using VolumeVaultInfra.Hug.Test.ControllersTests.AuthControllerTests.FakeData;

namespace VolumeVaultInfra.Hug.Test.ControllersTests.AuthControllerTests;

public class AuthControllerExceptionsTest
{
    private AuthController authController { get; }
    private Mock<ILogger> logger { get; } = new();
    private Mock<IAuthRepository> authRepository { get; } = new();
    private Mock<IUserIdentifierRepository> userIdentifierRepository { get; } = new();
    private Mock<IEmailUserIdentifierRepository> emailUserIdentifierRepository { get; } = new();

    public AuthControllerExceptionsTest()
    {
        authController = new(logger.Object, authRepository.Object, userIdentifierRepository.Object, emailUserIdentifierRepository.Object);
    }
    
    [Fact]
    public async void GetUserFromAuthIdentifierUserDoesNotExistsExceptionTest()
    {
        const string userIdentifier = "0";
        UserIdentifier returnedUserIdentifier = AuthFakeData.fakeUserIdentifier;
        UserInfo? returnedUserInfo = null;
        
        userIdentifierRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(returnedUserIdentifier);
        authRepository.Setup(ex => ex.GetUser(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(returnedUserInfo);
        
        await Assert.ThrowsAsync<UserDoesNotExistsException>(() => 
            authController.GetUserFromAuthWIdentifier(userIdentifier));
    }
    
    [Fact]
    public async void GetUserFromAuthEmailUserEmailDoesNotExitsExceptionTest()
    {
        const string userEmail = "test@test.com";
        EmailUserIdentifier returnedUserIdentifier = AuthFakeData.fakeEmailUserIdentifierNoUser;
        UserInfo? returnedUserInfo = null;
        
        emailUserIdentifierRepository.Setup(ex => ex.EnsureEmailExists(It.IsAny<EmailUserIdentifier>()))
            .ReturnsAsync(returnedUserIdentifier);
        authRepository.Setup(ex => ex.GetUserByEmail(It.IsAny<EmailUserIdentifier>()))
            .ReturnsAsync(returnedUserInfo);
        
        await Assert.ThrowsAsync<UserEmailDoesNotExitsException>(() => authController.GetUserFromAuthWEmail(userEmail));
    }
}