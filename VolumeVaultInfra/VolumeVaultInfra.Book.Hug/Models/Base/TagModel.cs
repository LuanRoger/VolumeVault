using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace VolumeVaultInfra.Book.Hug.Models.Base;

[Table("Tags")]
[Index(nameof(tag), IsUnique = true)]
public class TagModel
{
    [Key]
    [Required]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    [Column("ID")]
    public int id { get; init; }
    
    [Required]
    [Column("Tag")]
    public required string tag { get; init; }
}