class UserLoginRequest {
  final String username;
  final String password;

  UserLoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, String> toJson() => {
        "username": username,
        "password": password,
      };
}
