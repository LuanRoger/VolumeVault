using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Models.Base;

[Table(("Badge"))]
public class BadgeModel
{
    [Key]
    [Required]
    [Column("ID")]
    public int id { get; set; }
    
    [Required]
    [Column("BadgeCode")]
    public BadgeCodes code { get; set; }
}