using FluentValidation;
using FluentValidation.Results;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Enums;
using VolumeVaultInfra.Book.Hug.Validators;

namespace VolumeVaultInfra.Hug.Test.ValidationTests;

public class UserBadgeWriteModelValidationTest
{
    [Theory]
    [MemberData(nameof(GetValidUserBadgeWriteModelParameters))]
    public async void ValidateUserBadgeModelValidTest(GiveUserBadgeRequest giveUserBadgeRequest)
    {
        IValidator<GiveUserBadgeRequest> validator = new UserBadgeWriteModelValidator();
        ValidationResult result = await validator.ValidateAsync(giveUserBadgeRequest);
        Assert.True(result.IsValid);
    }
    [Theory]
    [MemberData(nameof(GetInvalidUserBadgeWriteModelParameters))]
    public async void ValidateUserBadgeModelInvalidTest(GiveUserBadgeRequest giveUserBadgeRequest)
    {
        IValidator<GiveUserBadgeRequest> validator = new UserBadgeWriteModelValidator();
        ValidationResult result = await validator.ValidateAsync(giveUserBadgeRequest);
        Assert.False(result.IsValid);
    }
    
    #region ValidUserBadgeWriteModel
    
    public static IEnumerable<object[]> GetValidUserBadgeWriteModelParameters()
    {
        foreach (GiveUserBadgeRequest userBadgeWriteModel in GetValidBadgeWriteModelParametersInput())
            yield return new object[] { userBadgeWriteModel };
    }
    private static IEnumerable<GiveUserBadgeRequest> GetValidBadgeWriteModelParametersInput()
    {
        return new []
        {
            new GiveUserBadgeRequest
            {
                userId = "0",
                badgeCode = BadgeCode.Tester
            }
        };
    }

    #endregion

    #region InvalidBadgeWriteModel

    public static IEnumerable<object[]> GetInvalidUserBadgeWriteModelParameters()
    {
        foreach (GiveUserBadgeRequest userBadgeWriteModel in GetInvalidBadgeWriteModelParametersInput())
            yield return new object[] { userBadgeWriteModel };
    }
    private static IEnumerable<GiveUserBadgeRequest> GetInvalidBadgeWriteModelParametersInput()
    {
        return new []
        {
            //User ID
            new GiveUserBadgeRequest
            {
                userId = "",
                badgeCode = BadgeCode.Tester
            },
        };
    }

    #endregion
}