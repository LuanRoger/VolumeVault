using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace VolumeVaultInfra.Book.Hug.Models.Base;

[Table("BadgeUser")]
public class BadgeUserModel
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    [Required]
    [Column("ID")]
    public int id { get; set; }
    
    [Required]
    [ForeignKey("BadgeCode")]
    public BadgeModel badge { get; set; }
    
    [Required]
    [ForeignKey("User")]
    public UserIdentifier userIdentifier { get; set; }
}