using VolumeVaultInfra.Models.Enums;

namespace VolumeVaultInfra.Models.Book;

public class BookSearchModel
{
    public int id { get; set; }
    public string? title { get; set; }
    public string? author { get; set; }
    
    public string? isbn { get; set; }
    
    public int? publicationYear { get; set; }
    
    public string? publisher { get; set; }
    
    public int? edition { get; set; }
    
    public int? pagesNumber { get; set; }
    
    public string? genre { get; set; }
    
    public BookFormat? format { get; set; }

    public bool? readed { get; set; }
    
    public List<string>? tags { get; set; }
    
    public DateTime? createdAt { get; set; }
    
    public static BookSearchModel FromBookModel(BookModel bookModel) => new()
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
        readed = bookModel.readed,
        tags = bookModel.tags,
        createdAt = bookModel.createdAt,
    };
}