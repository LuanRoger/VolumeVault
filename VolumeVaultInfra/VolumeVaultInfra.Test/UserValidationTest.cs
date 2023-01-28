using FluentValidation;
using FluentValidation.Results;
using VolumeVaultInfra.Models.User;
using VolumeVaultInfra.Validators;

namespace VolumeVaultInfra.Test;

public class UserValidationTest
{
    [Theory]
    [MemberData(nameof(GetValidUserWriteModel))]
    public void ValidateValidUserWriteModels(UserWriteModel userWriteModel)
    {
        IValidator<UserWriteModel> validator = new UserWriteModelValidator();
        ValidationResult result = validator.Validate(userWriteModel);
        Assert.True(result.IsValid);
    }
    
    [Theory]
    [MemberData(nameof(GetInvalidUserWriteModels))]
    public void ValidateInvalidUserWriteModels(UserWriteModel userWriteModel)
    {
        IValidator<UserWriteModel> validator = new UserWriteModelValidator();
        ValidationResult result = validator.Validate(userWriteModel); 
        Assert.False(result.IsValid);
    }

    #region ValidUserWriteModelsInput
    public static IEnumerable<object[]> GetValidUserWriteModel()
    {
        foreach (UserWriteModel input in GetValidUserWirteModelInput())
            yield return new object[] { input };
    }
    private static IEnumerable<UserWriteModel> GetValidUserWirteModelInput()
    {
        return new[]
        {
            //General
            new UserWriteModel
            {
                username = "123",
                email = "test@test.com",
                password = "12345678"
            },
            //Username
            new UserWriteModel
            {
                username = "systemuser123",
                email = "test@test.com",
                password = "12345678"
            },
            new UserWriteModel
            {
                username = "System User 123",
                email = "test@test.com",
                password = "12345678"
            },
            new UserWriteModel
            {
                username = "-*/-/123123dfsdf2*42*3/",
                email = "test@test.com",
                password = "12345678"
            },
            //Email
            new UserWriteModel
            {
                username = "123",
                email = "test123@test.com",
                password = "12345678"
            },
            new UserWriteModel
            {
                username = "123",
                email = "user.123@test.com",
                password = "12345678"
            },
            new UserWriteModel
            {
                username = "123",
                email = "test@test.com.br",
                password = "12345678"
            },
            //Password
            new UserWriteModel
            {
                username = "123",
                email = "test@test.com",
                password = "238328737*-/*-"
            },
            new UserWriteModel
            {
                username = "123",
                email = "test@test.com",
                password = "##hf/**%$%¨$fsjdjf"
            },
            new UserWriteModel
            {
                username = "123",
                email = "test@test.com",
                password = "12345678"
            },
            new UserWriteModel
            {
                username = "123",
                email = "test@test.com",
                password = "123456789123456789"
            },
        };
    }
    #endregion
    
    #region InvalidUserWriteModelsInputs
    public static IEnumerable<object[]> GetInvalidUserWriteModels()
    {
        foreach (UserWriteModel input in GetInvalidUserWriteModelsInput())
            yield return new object[] { input };
    }
    
    private static IEnumerable<UserWriteModel> GetInvalidUserWriteModelsInput()
    {
        return new[]
        {
            //General
            new UserWriteModel
            {
                username = string.Empty,
                email = string.Empty,
                password = string.Empty
            },
            new UserWriteModel
            {
                username = "12",
                email = string.Empty,
                password = "1234567"
            },
            //Usename
            new UserWriteModel
            {
                username = "",
                email = "test.test@test.com",
                password = "12345678"
            },
            //Email
            new UserWriteModel
            {
                username = "123",
                email = "test.test@.com",
                password = "12345678"
            },
            new UserWriteModel
            {
                username = "123",
                email = "test.test@test.c",
                password = "12345678"
            },
            new UserWriteModel
            {
                username = "123",
                email = "@test.com",
                password = "12345678"
            },
            new UserWriteModel
            {
                username = "123",
                email = "test.test@test.c",
                password = "12345678"
            },
            //Password
            new UserWriteModel
            {
                username = "123",
                email = "test.test@test.com",
                password = "1234567891234567891"
            }
        };
    }
    #endregion
}