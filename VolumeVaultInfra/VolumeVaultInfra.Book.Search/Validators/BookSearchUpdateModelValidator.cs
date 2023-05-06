using FluentValidation;
using VolumeVaultInfra.Book.Search.Models;

namespace VolumeVaultInfra.Book.Search.Validators;

public class BookSearchUpdateModelValidator : AbstractValidator<BookSearchUpdateModel>
{
    public BookSearchUpdateModelValidator()
    {
        RuleFor(book => book.title)
            .NotEmpty()
            .When(book => book.title is not null);
        RuleFor(book => book.author)
            .NotEmpty()
            .When(book => book.author is not null);
        RuleFor(book => book.isbn)
            .NotEmpty()
            .Length(17)
            .When(book => book.isbn is not null);
        RuleFor(book => book.publicationYear)
            .GreaterThanOrEqualTo(1)
            .When(book => book.publicationYear is not null);
        RuleFor(book => book.publisher)
            .NotEmpty()
            .MaximumLength(100)
            .When(book => book.publisher is not null);
        RuleFor(book => book.edition)
            .NotEmpty()
            .When(book => book.edition is not null);
        RuleFor(book => book.pagesNumber)
            .GreaterThanOrEqualTo(1)
            .When(book => book.pagesNumber is not null);
        RuleFor(book => book.genre)
            .NotEmpty()
            .MaximumLength(50)
            .When(book => book.genre is not null);
        RuleFor(book => book.format)
            .IsInEnum()
            .When(book => book.format is not null);
        RuleFor(book => book.readStartDay)
            .Null()
            .When(book => book.readStatus is not null && book.readStatus == ReadStatus.NotRead);
        RuleFor(book => book.readEndDay)
            .Null()
            .When(book => book.readStatus is not null && book.readStatus == ReadStatus.NotRead);
        RuleFor(book => book.readEndDay)
            .GreaterThanOrEqualTo(book => book.readStartDay)
            .When(book => book.readStartDay is not null);
        RuleFor(book => book.readStatus)
            .NotEmpty()
            .When(book => book.readStatus is not null);
        RuleForEach(book => book.tags)
            .NotEmpty()
            .MaximumLength(20)
            .When(book => book.tags is not null);
    }
}