using VolumeVaultInfra.Models.Enums;
// ReSharper disable MemberCanBePrivate.Global
// ReSharper disable UnusedAutoPropertyAccessor.Global

namespace VolumeVaultInfra.Models.Book;

public class BookSearchReadModel
{
    public required int id { get; init; }
    public required string title { get; init; }
    
    public required string author { get; init; }
    
    public required string isbn { get; init; }
    
    public int? publicationYear { get; init; }
    
    public string? publisher { get; init; }
    
    public int? edition { get; init; }
    
    public int? pagesNumber { get; init; }
    
    public string? genre { get; init; }
    
    public BookFormat? format { get; init; }
    
    public ReadStatus? readStatus { get; init; }
    
    public DateTime? readStartDay { get; init; }
    
    public DateTime? readEndDay { get; init; }

    public List<string>? tags { get; init; }
    
    public required DateTime createdAt { get; init; }
    
    public required DateTime lastModification { get; init; }
    
    public int ownerId { get; init; }
    
    public static BookSearchReadModel FromSearchModel(BookSearchModel bookSearchModel) => new()
    {
        id = bookSearchModel.id,
        title = bookSearchModel.title,
        author = bookSearchModel.author,
        isbn = bookSearchModel.isbn,
        publicationYear = bookSearchModel.publicationYear,
        publisher = bookSearchModel.publisher,
        edition = bookSearchModel.edition,
        pagesNumber = bookSearchModel.pagesNumber,
        genre = bookSearchModel.genre,
        format = bookSearchModel.format,
        readStatus = bookSearchModel.readStatus,
        readStartDay = bookSearchModel.readStartDay,
        readEndDay = bookSearchModel.readEndDay,
        tags = bookSearchModel.tags,
        createdAt = bookSearchModel.createdAt,
        lastModification = bookSearchModel.lastModification,
        ownerId = bookSearchModel.ownerId
    };
}