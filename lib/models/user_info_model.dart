class UserInfoModel {
  int id;
  String username;

  UserInfoModel(this.id, {required this.username});

  Map<String, dynamic> toJson() => {
        "id": id,
        "userIdentifier": username,
      };
  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        json["id"] as int,
        username: json["userIdentifier"] as String,
      );
}
