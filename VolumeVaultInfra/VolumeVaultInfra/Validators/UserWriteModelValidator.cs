using FluentValidation;
using VolumeVaultInfra.Models.User;

namespace VolumeVaultInfra.Validators;

public class UserWriteModelValidator : AbstractValidator<UserWriteModel>
{
    public UserWriteModelValidator()
    {
        RuleFor(user => user.username)
            .NotEmpty()
            .MinimumLength(3);
        RuleFor(user => user.email)
            .Matches(ValidationRegexConsts.VALID_EMAIL_REGEX);
        RuleFor(user => user.password)
            .NotEmpty()
            .MinimumLength(8)
            .MaximumLength(18);
    }
}