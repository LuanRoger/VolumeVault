namespace VolumeVaultInfra.Book.Hug.Models;

public class UserInfo
{
    public string uid { get; set; }
    public string displayName { get; set; }
    public string email { get; set; }
    public bool verifiedEmail { get; set; }
    public bool disabled { get; set; }
}