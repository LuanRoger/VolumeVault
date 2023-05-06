using VolumeVaultInfra.Book.Models.Enums;

// ReSharper disable MemberCanBePrivate.Global
// ReSharper disable UnusedAutoPropertyAccessor.Global

namespace VolumeVaultInfra.Book.Models.Book;

public class BookReadModel
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
    
    public string? observation { get; init; }
    
    public string? synopsis { get; init; }
    
    public string? coverLink { get; init; }
    
    public string? buyLink { get; init; }
    
    public ReadStatus? readStatus { get; init; }
    
    public DateTime? readStartDay { get; init; }
    
    public DateTime? readEndDay { get; init; }
    
    public List<string>? tags { get; init; }

    public required DateTime createdAt { get; init; }
    
    public required DateTime lastModification { get; init; }

    public required string owner { get; init; }
    
    public static BookReadModel FromBookModel(BookModel bookModel) => new()
    {
        id = bookModel.id,
        title = bookModel.title,
        author = bookModel.author,
        isbn = bookModel.isbn,
        publicationYear = bookModel.publicationYear,
        publisher = bookModel.publisher,
        edition = bookModel.edition,
        pagesNumber = bookModel.pagesNumber,
        genre = bookModel.genre,
        format = bookModel.format,
        observation = bookModel.observation,
        synopsis = bookModel.synopsis,
        coverLink = bookModel.coverLink,
        buyLink = bookModel.buyLink,
        readStatus = bookModel.readStatus,
        readStartDay = bookModel.readStartDay,
        readEndDay = bookModel.readEndDay,
        tags = bookModel.tags,
        createdAt = bookModel.createdAt,
        lastModification = bookModel.lastModification,
        owner = bookModel.owner
    };
}