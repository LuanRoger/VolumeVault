using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace VolumeVaultInfra.Book.Hug.Models.Base;

[Table("BookGenre")]
public class BookGenreModel
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    [Required]
    [Column("ID")]
    public int id { get; init; }
    
    [ForeignKey("Book")]
    [Required]
    public required BookModel book { get; init; }
    
    [ForeignKey("Genre")]
    [Required]
    public required GenreModel genre { get; init; }
    
    [ForeignKey("UserIdentifier")]
    public UserIdentifier userIdentifier { get; init; }
}