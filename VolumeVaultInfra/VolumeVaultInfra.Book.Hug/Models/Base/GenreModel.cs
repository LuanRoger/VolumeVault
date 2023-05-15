using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace VolumeVaultInfra.Book.Hug.Models.Base;

[Table("Genres")]
[Index(nameof(genre), IsUnique = true)]
public class GenreModel
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    [Required]
    [Column("ID")]
    public int id { get; init; }
    
    [Required]
    [MaxLength(50)]
    [Column("Genre")]
    public required string genre { get; init; }
}