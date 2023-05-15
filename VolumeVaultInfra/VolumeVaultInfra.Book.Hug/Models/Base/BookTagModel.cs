using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace VolumeVaultInfra.Book.Hug.Models.Base;

[Table("BookTag")]
public class BookTagModel
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    [Required]
    [Column("ID")]
    public int id { get; init; }
    
    [ForeignKey("BookId")]
    [Required]
    public required BookModel book { get; init; }
    
    [ForeignKey("TagId")]
    [Required]
    public required TagModel tag { get; init; }
}