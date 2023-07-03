using FluentValidation;
using VolumeVaultInfra.Book.Hug.Models;

namespace VolumeVaultInfra.Book.Hug.Validators;

public class UserBadgeWriteModelValidator : AbstractValidator<GiveUserBadgeRequest>
{
    public UserBadgeWriteModelValidator()
    {
        RuleFor(model => model.userId)
            .NotNull()
            .NotEmpty();
        RuleFor(model => model.badgeCode)
            .IsInEnum();
    }
}