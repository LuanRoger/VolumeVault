namespace VolumeVaultInfra.Models.User;

public class UserLoginRequestModel
{
    public required string username { get; init; }
    public required string password { get; init; }
}