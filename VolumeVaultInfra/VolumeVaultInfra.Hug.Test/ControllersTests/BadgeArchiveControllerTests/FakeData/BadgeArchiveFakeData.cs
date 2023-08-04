using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Hug.Test.ControllersTests.BadgeArchiveControllerTests.FakeData;

public static class BadgeArchiveFakeData
{
    public static ClaimUserBadgesRequest fakeClaimUserBadgesRequest => new()
    {
        email = "test@test.com",
        claimedAt = DateTime.Now
    };
    public static AttachBadgeToEmailRequest fakeAttachBadgeToEmailRequest => new()
    {
        email = "test@test.com",
        attachDate = DateTime.Now,
        badgeCode = BadgeCode.Tester
    };
    public static UserIdentifier fakeUserIdentifier => new()
    {
        userIdentifier = "0"
    };
    public static UserInfo fakeUserInfo => new()
    {
        uid = "0",
        email = "test@test.com",
        disabled = false,
        displayName = "tester",
        verifiedEmail = false
    };
    public static EmailUserIdentifier fakeEmailUserIdentifierNoUser => new()
    {
        email = "test@test.com",
        userIdentifier = null
    };
    public static BadgeModel fakeBadgeModel => new()
    {
        code = BadgeCode.Tester
    };
    public static IReadOnlyList<BadgeModel> fakeBadgeModelList => new List<BadgeModel>()
    {
        new()
        {
            code = BadgeCode.Tester
        },
        new()
        {
            code = BadgeCode.Tester
        },
        new()
        {
            code = BadgeCode.Tester
        }
    };
}