namespace VolumeVaultInfra.Book.Hug.Models;

public class UserInfo
{
    public string uid { get; set; }
    public string name { get; set; }
    public string email { get; set; }
    public bool verifiedEmail { get; set; }
    public bool disabled { get; set; }
}