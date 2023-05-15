using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Models;

public class BookUpdateModel
{
    public string? title { get; init; }
    
    public string? author { get; init; }
    
    public string? isbn { get; init; }
    
    public int? publicationYear { get; init; }
    
    public string? publisher { get; init; }
    
    public int? edition { get; init; }
    
    public int? pagesNumber { get; init; }
    
    public List<string>? genre { get; init; }
    
    public BookFormat? format { get; init; }
    
    public string? observation { get; init; }
    
    public string? synopsis { get; init; }
    
    public string? coverLink { get; init; }
    
    public string? buyLink { get; init; }
    
    public ReadStatus? readStatus { get; init; }
    
    public DateTime? readStartDay { get; init; }
    
    public DateTime? readEndDay { get; init; }
    
    public List<string>? tags { get; init; }
    
    public DateTime lastModification { get; init; } 
}