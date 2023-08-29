class UserSession {
  String uid;
  String name;
  String email;
  bool verified;

  UserSession({
    required this.uid,
    required this.name,
    required this.email,
    required this.verified,
  });
}
