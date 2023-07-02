using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using UserIdentifier = VolumeVaultInfra.Book.Hug.Models.Base.UserIdentifier;

namespace VolumeVaultInfra.Hug.Test.ControllersTests.AuthControllerTests.FakeData;

public static class AuthFakeData
{
    public static UserIdentifier fakeUserIdentifier => new()
    {
        userIdentifier = "0"
    };
    public static EmailUserIdentifier fakeEmailUserIdentifierNoUser => new()
    {
        email = "test@test.com",
        userIdentifier = null
    };
    public static UserInfo fakeUserInfo => new()
    {
        uid = "0",
        email = "test@test.com",
        disabled = false,
        name = "tester",
        verifiedEmail = false
    };
}