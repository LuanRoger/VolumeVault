using FluentValidation;
using VolumeVaultInfra.Book.Hug.Models;

namespace VolumeVaultInfra.Book.Hug.Validators;

public class AttachBadgeToEmailRequestValidator : AbstractValidator<AttachBadgeToEmailRequest>
{
    public AttachBadgeToEmailRequestValidator()
    {
        RuleFor(model => model.email).NotEmpty().EmailAddress();
        RuleFor(model => model.badgeCode).IsInEnum();
        RuleFor(model => model.attachDate).NotEmpty();
    }
}