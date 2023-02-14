using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Models.Enums;

namespace VolumeVaultInfra.Models.Book;

public class BookWriteModel
{
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
    
    public bool? readed { get; init; }
    
    public List<string>? tags { get; init; }
    
    public required DateTime createdAt { get; init; }
    
    public required DateTime lastModification { get; init; }
}