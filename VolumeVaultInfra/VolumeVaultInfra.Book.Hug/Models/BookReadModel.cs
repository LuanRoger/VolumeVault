using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Enums;

// ReSharper disable MemberCanBePrivate.Global
// ReSharper disable UnusedAutoPropertyAccessor.Global

namespace VolumeVaultInfra.Book.Hug.Models;

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
    
    public List<string>? genre { get; set; }
    
    public BookFormat? format { get; init; }
    
    public string? observation { get; init; }
    
    public string? synopsis { get; init; }
    
    public string? coverLink { get; init; }
    
    public string? buyLink { get; init; }
    
    public ReadStatus? readStatus { get; init; }
    
    public DateTime? readStartDay { get; init; }
    
    public DateTime? readEndDay { get; init; }
    
    public List<string>? tags { get; set; }

    public required DateTime createdAt { get; init; }
    
    public required DateTime lastModification { get; init; }

    public required UserIdentifier owner { get; init; }
}