﻿namespace VolumeVaultInfra.Book.Search.Models;

public class BookSearchModel
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
    
    public string ownerId { get; init; }
}