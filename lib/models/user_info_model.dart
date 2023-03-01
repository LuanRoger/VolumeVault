class UserInfoModel {
  int id;
  String username;
  String email;

  UserInfoModel(this.id, {required this.username, required this.email});

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
      };
  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        json["id"] as int,
        username: json["username"] as String,
        email: json["email"] as String,
      );
}
