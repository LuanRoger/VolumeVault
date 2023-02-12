// ReSharper disable UnusedAutoPropertyAccessor.Global
// ReSharper disable MemberCanBePrivate.Global
namespace VolumeVaultInfra.Models.User;

public class UserReadModel
{
    public required int id { get; init; }
    public required string username { get; init; }
    public required string email { get; init; }
    
    public static UserReadModel FromUserModel(UserModel userModel) => new()
    {
        id = userModel.id,
        username = userModel.username,
        email = userModel.email
    };
}