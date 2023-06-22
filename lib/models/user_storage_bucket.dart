import 'package:path/path.dart' as path;

class UserStorageBucket {
  final String _uid;
  final String _username;
  final String _email;

  String get internalUserFolder => "$_username.$_email.$_uid";
  static const String profileImageName = "profile_image";
  static const String profileBackgroundName = "profile_background";

  String get userBaseBucketPath => path.join("users", internalUserFolder);

  String get profileImagePath =>
      path.join("users", internalUserFolder, profileImageName);
  String get profileBackgroundImagePath =>
      path.join("users", internalUserFolder, profileBackgroundName);

  UserStorageBucket(
      {required String uid, required String username, required String email})
      : _email = email,
        _username = username,
        _uid = uid;
}
