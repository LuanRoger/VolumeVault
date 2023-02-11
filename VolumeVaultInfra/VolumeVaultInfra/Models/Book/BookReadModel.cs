using VolumeVaultInfra.Models.Enums;
using VolumeVaultInfra.Models.User;

namespace VolumeVaultInfra.Models.Book;

public class BookReadModel
{
    public int id { get; set; }
    public string title { get; set; }
    
    public string author { get; set; }
    
    public string isbn { get; set; }
    
    public int? publicationYear { get; set; }
    
    public string? publisher { get; set; }
    
    public int? edition { get; set; }
    
    public int? pagesNumber { get; set; }
    
    public string? genre { get; set; }
    
    public BookFormat? format { get; set; }
    
    public string? observation { get; set; }
    
    public string? synopsis { get; set; }
    
    public string? coverLink { get; set; }
    
    public string? buyLink { get; set; }
    
    public bool? readed { get; set; }
    
    public List<string>? tags { get; set; }
    
    public DateTime createdAt { get; set; }
    
    public UserReadModel owner { get; set; }
    
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
        readed = bookModel.readed,
        tags = bookModel.tags,
        createdAt = bookModel.createdAt,
        owner = UserReadModel.FromUserModel(bookModel.owner),
    };
}