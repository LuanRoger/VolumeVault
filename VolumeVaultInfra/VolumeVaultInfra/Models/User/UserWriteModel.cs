namespace VolumeVaultInfra.Models.User;

public class UserWriteModel
{
    public required string username { get; init; }
    public required string email { get; init; }
    public required string password { get; init; }
}