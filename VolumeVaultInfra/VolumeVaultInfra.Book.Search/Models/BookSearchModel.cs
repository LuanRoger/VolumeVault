using VolumeVaultInfra.Book.Search.Models.Enums;

namespace VolumeVaultInfra.Book.Search.Models;

public class BookSearchModel
{
    public required string id { get; set; }
    
    public required string title { get; init; }
    
    public required string author { get; init; }
    
    public required string isbn { get; init; }
    
    public int? publicationYear { get; init; }
    
    public string? publisher { get; init; }
    
    public int? edition { get; init; }
    
    public int? pagesNumber { get; init; }
    
    public List<string>? genre { get; set; }
    
    public BookFormat? format { get; init; }
    
    public ReadStatus? readStatus { get; init; }
    
    public DateTime? readStartDay { get; init; }
    
    public DateTime? readEndDay { get; init; }

    public List<string>? tags { get; set; }
    
    public required DateTime createdAt { get; init; }
    
    public required DateTime lastModification { get; init; }
    
    public string ownerId { get; set; }
}