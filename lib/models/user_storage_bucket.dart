import 'package:path/path.dart' as path;

class UserStorageBucket {
  final String _uid;
  final String _username;
  final String _email;

  static const String imageExtension = ".jpg";
  static const String profileImageName = "profile_image$imageExtension";
  static const String profileBackgroundName =
      "profile_background$imageExtension";

  String get userBaseBucketPath =>
      path.join("users", "$_username.$_email.$_uid");
  String get profileImageRef =>
      path.join(userBaseBucketPath, profileImageName);
  String get profileBackgroundRef =>
      path.join(userBaseBucketPath, profileBackgroundName);

  UserStorageBucket(
      {required String uid, required String username, required String email})
      : _email = email,
        _username = username,
        _uid = uid;
}
