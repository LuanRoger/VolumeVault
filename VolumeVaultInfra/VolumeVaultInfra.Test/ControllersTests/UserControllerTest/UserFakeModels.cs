using VolumeVaultInfra.Models.User;

namespace VolumeVaultInfra.Test.ControllersTests.UserControllerTest;

internal static class UserFakeModels
{
    public static UserModel userTestDumy => new()
    {
        id = 1,
        username = "test",
        email = "test@test.com",
        password = "0+Yf74CcualNvW/7BnpJW6pFcivVb4Mc6/ye2qETuLqZsw9m6jENtOL/QBjAiKUQDIIYMzLXs8IbH2fBCw8bKw=="
    };

    public static UserWriteModel userWriteTestDumy => new()
    {
        username = "test",
        email = "test@test.com",
        password = "test1234"
    };
    public static UserLoginRequestModel loginRequestTestDumy => new()
    {
        username = "test",
        password = "test1234"
    };
}