using System.Linq.Expressions;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Models.Utils;

public class BookSortOptions
{
    public required BookSort? sortOptions { get; init; }
    public bool ascending { get; init; } = true;
    
    public Expression<Func<BookModel, object>> GetExpression() => sortOptions is not null ? sortOptions switch
    {
        BookSort.Title => book => book.title,
        BookSort.Author => book => book.author,
        BookSort.ReleaseDate => book => book.publicationYear!,
        BookSort.Publisher => book => book.publisher!,
        BookSort.Pages => book => book.pagesNumber!,
        BookSort.ReadStartDay => book => book.readStartDay!,
        BookSort.ReadEndDay => book => book.readEndDay!,
        BookSort.CreationDate => book => book.createdAt,
        _ => throw new ArgumentOutOfRangeException()
    } : book => book.id;
}