using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace VolumeVaultInfra.Book.Hug.Models.Base;

[Table("EmailUserIdentifier")]
[Index(nameof(email), IsUnique = true)]
public class EmailUserIdentifier
{
    [Key]
    [Required]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    [Column("ID")]
    public int id { get; set; }
    
    [Required]
    [Column("Email")]
    public string email { get; set; }
    
    [ForeignKey("UserIdentifier")]
    public UserIdentifier? userIdentifier { get; set; }
}