class UserSiginRequest {
  final String username;
  final String email;
  final String password;

  UserSiginRequest({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "password": password,
      };
}
