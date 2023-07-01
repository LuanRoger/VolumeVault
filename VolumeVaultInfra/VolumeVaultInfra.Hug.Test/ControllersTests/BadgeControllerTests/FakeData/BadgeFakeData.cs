using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Hug.Test.ControllersTests.BadgeControllerTests.FakeData;

public static class BadgeFakeData
{
    public static UserIdentifier fakeUserIdentifier => new()
    {
        id = 1,
        userIdentifier = "0"
    };
    public static UserBadgeWriteModel fakeUserBadgeWriteModel => new()
    {
        userId = "0",
        badgeCode = BadgeCode.Tester
    };
    public static UserBadgeWriteModel fakeInvalidUserBadgeWriteModel => new()
    {
        userId = "",
        badgeCode = BadgeCode.Tester
    };
    
    public static BadgeModel fakeBadgeModel => new()
    {
        id = 1,
        code = BadgeCode.Tester
    };
}