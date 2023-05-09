using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace VolumeVaultInfra.Book.Hug.Models.Base;

[Table("UserIdentifier")]
[Index(nameof(userIdentifier), IsUnique = true)]
public class UserIdentifier
{
    [Key]
    [Required]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    [Column("ID")]
    public int id { get; init; }
    
    [Column("UserIdentifier")]
    public required string userIdentifier { get; init; }
}