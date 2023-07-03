namespace VolumeVaultInfra.Book.Hug.Models;

public class ClaimUserBadgesRequest
{
    public string email { get; set; }
    public DateTime claimedAt { get; set; }
}