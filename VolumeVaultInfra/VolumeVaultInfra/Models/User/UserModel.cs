using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace VolumeVaultInfra.Models.User;

[Table("Users")]
public class UserModel
{
    [Key]
    [Required]
    [Column("ID")]
    public int id { get; set; }
    
    [Required]
    [Column("Username")]
    [MaxLength(50)]
    public string username { get; set; }
    
    [Required]
    [Column("Email")]
    [MaxLength(100)]
    public string email { get; set; }
    
    [Required]
    [Column("Password")]
    [MaxLength(90)]
    public string password { get; set; }
}