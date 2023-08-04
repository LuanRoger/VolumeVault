using FluentValidation;
using VolumeVaultInfra.Book.Hug.Models;

namespace VolumeVaultInfra.Book.Hug.Validators;

public class ClaimUserBadgeRequestValidator : AbstractValidator<ClaimUserBadgesRequest>
{
    public ClaimUserBadgeRequestValidator()
    {
        RuleFor(model => model.email)
            .NotEmpty()
            .EmailAddress();
        RuleFor(model => model.claimedAt)
            .GreaterThanOrEqualTo(DateTime.Now);
    }
}