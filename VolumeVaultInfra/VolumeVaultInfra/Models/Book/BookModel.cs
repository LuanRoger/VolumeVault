﻿using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using VolumeVaultInfra.Models.Enums;
using VolumeVaultInfra.Models.User;

namespace VolumeVaultInfra.Models.Book;

[Table("Books")]
public class BookModel
{
    [Key]
    [Required]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    [Column("ID")]
    public int id { get; set; }
    
    [Column("Title")]
    [MaxLength(100)]
    public required string title { get; set; }
    
    [Column("Author")]
    public required string author { get; set; }
    
    [Column("ISBN")]
    [MaxLength(17)]
    public required string isbn { get; set; }
    
    [Column("PublicationYear")]
    public int? publicationYear { get; set; }

    [Column("Publisher")]
    [MaxLength(100)]
    public string? publisher { get; set; }
    
    [Column("Edition")]
    public int? edition { get; set; }
    
    [Column("PagesNumber")]
    public int? pagesNumber { get; set; }
    
    [Column("Genres")]
    [MaxLength(50)]
    public string? genre { get; set; }
    
    [Column("Format")]
    public BookFormat? format { get; set; }
    
    [Column("Obsevation")]
    public string? observation { get; set; }
    
    [Column("Synopsis")]
    [MaxLength(300)]
    public string? synopsis { get; set; }
    
    [Column("CoverLink")]
    [MaxLength(500)]
    public string? coverLink { get; set; }
    
    [Column("BuyLink")]
    [MaxLength(500)]
    public string? buyLink { get; set; }
    
    [Column("Readed")]
    public bool? readed { get; set; }
    
    [Column("Tags")]
    public List<string>? tags { get; set; }
    
    [Column("CreatedAt")]
    public required DateTime createdAt { get; set; }
    
    [Column("LastModification")]
    public required DateTime lastModification { get; set; } 
    
    [Column("Owner")]
    public required UserModel owner { get; set; }
}