using FluentValidation;
using VolumeVaultInfra.Book.Models.Book;
using VolumeVaultInfra.Book.Models.Enums;

namespace VolumeVaultInfra.Book.Validators;

public class BookUpdateModelValidator : AbstractValidator<BookUpdateModel>
{
    public BookUpdateModelValidator()
    {
        
    }
}