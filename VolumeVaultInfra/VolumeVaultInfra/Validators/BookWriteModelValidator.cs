using FluentValidation;
using VolumeVaultInfra.Models.Book;

namespace VolumeVaultInfra.Validators;

public class BookWriteModelValidator : AbstractValidator<BookWriteModel>
{
    public BookWriteModelValidator()
    {
        RuleFor(book => book.title).NotEmpty();
        RuleFor(book => book.author).NotEmpty();
        RuleFor(book => book.isbn)
            .NotEmpty()
            .Length(17);
        RuleFor(book => book.publicationYear)
            .GreaterThanOrEqualTo(0)
            .When(book => book.publicationYear is not null);
        RuleFor(book => book.publisher)
            .NotEmpty()
            .MaximumLength(100)
            .When(book => book.publisher is not null);
        RuleFor(book => book.edition)
            .NotEmpty()
            .GreaterThanOrEqualTo(1)
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
        RuleFor(book => book.observation)
            .NotEmpty()
            .When(book => book.observation is not null);
        RuleFor(book => book.synopsis)
            .NotEmpty()
            .MaximumLength(300)
            .When(book => book.synopsis is not null);
        RuleFor(book => book.coverLink)
            .NotEmpty()
            .MaximumLength(500)
            .When(book => book.coverLink is not null);
        RuleFor(book => book.buyLink)
            .NotEmpty()
            .MaximumLength(500)
            .When(book => book.buyLink is not null);
        RuleFor(book => book.readed)
            .NotEmpty()
            .When(book => book.readed is not null);
        RuleForEach(book => book.tags)
            .NotEmpty()
            .MaximumLength(20)
            .When(book => book.tags is not null);
    }
}