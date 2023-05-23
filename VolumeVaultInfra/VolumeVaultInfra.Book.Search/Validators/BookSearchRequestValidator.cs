using FluentValidation;
using VolumeVaultInfra.Book.Search.Models;

namespace VolumeVaultInfra.Book.Search.Validators;

public class BookSearchRequestValidator : AbstractValidator<BookSearchRequest>
{
    public BookSearchRequestValidator()
    {
        RuleFor(model => model.query)
            .MaximumLength(50);
        RuleFor(model => model.limitPerSection)
            .GreaterThanOrEqualTo(1);
    }
}