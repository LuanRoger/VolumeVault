using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace VolumeVaultInfra.Book.Hug.Models.Base;

[Table("BadgeEmailUser")]
public class BadgeEmailUserModel
{
    [Required]
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    [Column("ID")]
    public int id { get; set; }
    
    [Required]
    [ForeignKey("EmailIdentifier")]
    public EmailUserIdentifier emailUserIdentifier { get; set; }
    
    [Required]
    [ForeignKey("Badge")]
    public BadgeModel badge { get; set; }
    
    [Required]
    [Column("AttachDateTime")]
    public DateTime attachDateTime { get; set; }
}