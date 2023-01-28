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
    
    public bool? readed { get; set; }
    
    public List<string>? tags { get; set; }
    
    public DateTime createdAt { get; set; }
    
    public UserModel owner { get; set; }
}