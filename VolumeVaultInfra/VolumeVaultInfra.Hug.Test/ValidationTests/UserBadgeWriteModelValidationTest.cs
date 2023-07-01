using System.Collections;
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
    public async void ValidateUserBadgeModelValidTest(UserBadgeWriteModel userBadgeWriteModel)
    {
        IValidator<UserBadgeWriteModel> validator = new UserBadgeWriteModelValidator();
        ValidationResult result = await validator.ValidateAsync(userBadgeWriteModel);
        Assert.True(result.IsValid);
    }
    [Theory]
    [MemberData(nameof(GetInvalidUserBadgeWriteModelParameters))]
    public async void ValidateUserBadgeModelInvalidTest(UserBadgeWriteModel userBadgeWriteModel)
    {
        IValidator<UserBadgeWriteModel> validator = new UserBadgeWriteModelValidator();
        ValidationResult result = await validator.ValidateAsync(userBadgeWriteModel);
        Assert.False(result.IsValid);
    }
    
    #region ValidUserBadgeWriteModel
    
    public static IEnumerable<object[]> GetValidUserBadgeWriteModelParameters()
    {
        foreach (UserBadgeWriteModel userBadgeWriteModel in GetValidBadgeWriteModelParametersInput())
            yield return new object[] { userBadgeWriteModel };
    }
    private static IEnumerable<UserBadgeWriteModel> GetValidBadgeWriteModelParametersInput()
    {
        return new []
        {
            new UserBadgeWriteModel
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
        foreach (UserBadgeWriteModel userBadgeWriteModel in GetInvalidBadgeWriteModelParametersInput())
            yield return new object[] { userBadgeWriteModel };
    }
    private static IEnumerable<UserBadgeWriteModel> GetInvalidBadgeWriteModelParametersInput()
    {
        return new []
        {
            //User ID
            new UserBadgeWriteModel
            {
                userId = "",
                badgeCode = BadgeCode.Tester
            },
        };
    }

    #endregion
}