namespace VolumeVaultInfra.Models.User;

public class UserReadModel
{
    public int id { get; set; }
    public string username { get; set; }
    public string email { get; set; }
    
    public static UserReadModel FromUserModel(UserModel userModel) => new()
    {
        id = userModel.id,
        username = userModel.username,
        email = userModel.email
    };
}