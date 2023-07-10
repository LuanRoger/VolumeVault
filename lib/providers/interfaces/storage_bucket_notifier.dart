import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:volume_vault/models/enums/image_upload_result.dart';
import 'package:volume_vault/models/user_storage_bucket.dart';
import 'package:volume_vault/shared/app_storage.dart';
import 'package:path/path.dart' as path;

class StorageBucketNotifier extends ChangeNotifier {
  UserStorageBucket? storageBucket;

  StorageBucketNotifier({this.storageBucket});
  bool get _isLogged => storageBucket != null;

  Future<File?> getProfileImageFromBucket() async {
    if (!_isLogged) return null;

    final profileUserFolder = await AppStorage.ensureCreatedAppDirectory(
        storageBucket!.internalUserFolder);
    final inAppProfileImage =
        path.join(profileUserFolder.path, UserStorageBucket.profileImageName);
    final inAppProfileImageFile = File(inAppProfileImage);
    if (inAppProfileImageFile.existsSync()) {
      return inAppProfileImageFile;
    }

    final storageBucketRef =
        FirebaseStorage.instance.ref(storageBucket!.userBaseBucketPath);
    final profileImageRef =
        storageBucketRef.child(UserStorageBucket.profileImageName);

    final writeTask = profileImageRef.writeToFile(inAppProfileImageFile);
    try {
      await writeTask;
    } catch (_) {
      return null;
    }

    if (writeTask.snapshot.state != TaskState.success) {
      return null;
    }

    return File(inAppProfileImageFile.path);
  }

  Future<File?> getProfileBackgroundImageFromBucket() async {
    if (!_isLogged) return null;

    final profileUserFolder = await AppStorage.ensureCreatedAppDirectory(
        storageBucket!.internalUserFolder);
    final inAppProfileBackgroundImage = path.join(
        profileUserFolder.path, UserStorageBucket.profileBackgroundName);
    final inAppProfileBackgroundImageFile = File(inAppProfileBackgroundImage);
    if (inAppProfileBackgroundImageFile.existsSync()) {
      return inAppProfileBackgroundImageFile;
    }

    final storageBucketRef =
        FirebaseStorage.instance.ref(storageBucket!.userBaseBucketPath);
    final profileBackgroundImageRef =
        storageBucketRef.child(UserStorageBucket.profileBackgroundName);

    final writeTask =
        profileBackgroundImageRef.writeToFile(inAppProfileBackgroundImageFile);
    try {
      await writeTask;
    } catch (_) {
      return null;
    }

    if (writeTask.snapshot.state != TaskState.success) {
      return null;
    }

    return File(inAppProfileBackgroundImageFile.path);
  }

  Future<ImageUploadResult> uploadProfileImage(File imageFile) async {
    if (!_isLogged) return ImageUploadResult.failedByUnknown;

    final imageExists = await imageFile.exists();
    if (!imageExists) return ImageUploadResult.failedByFileNotFound;

    final storageBucketRef =
        FirebaseStorage.instance.ref(storageBucket!.profileImagePath);
    UploadTask uploadTask = storageBucketRef.putFile(imageFile);
    await uploadTask;

    final appProfileFolder = await AppStorage.ensureCreatedAppDirectory(
        storageBucket!.internalUserFolder);
    final inAppProfileImagePath =
        path.join(appProfileFolder.path, UserStorageBucket.profileImageName);
    await imageFile.copy(inAppProfileImagePath);

    notifyListeners();
    return switch (uploadTask.snapshot.state) {
      TaskState.success => ImageUploadResult.success,
      TaskState.canceled => ImageUploadResult.successInLocalStorage,
      TaskState.error => ImageUploadResult.successInLocalStorage,
      _ => ImageUploadResult.failedByUnknown
    };
  }

  Future<ImageUploadResult> uploadBackgroundImage(File imageFile) async {
    if (!_isLogged) return ImageUploadResult.failedByUnknown;

    final imageExists = await imageFile.exists();
    if (!imageExists) return ImageUploadResult.failedByFileNotFound;

    final storageBucketRef =
        FirebaseStorage.instance.ref(storageBucket!.profileBackgroundImagePath);
    UploadTask uploadTask = storageBucketRef.putFile(imageFile);
    await uploadTask;

    final inAppBackgroundImagePath = await AppStorage.ensureCreatedAppDirectory(
        storageBucket!.internalUserFolder);
    final inAppProfileBackgroundImagePath = path.join(
        inAppBackgroundImagePath.path, UserStorageBucket.profileBackgroundName);
    await imageFile.copy(inAppProfileBackgroundImagePath);

    notifyListeners();
    return switch (uploadTask.snapshot.state) {
      TaskState.success => ImageUploadResult.success,
      TaskState.canceled => ImageUploadResult.successInLocalStorage,
      TaskState.error => ImageUploadResult.successInLocalStorage,
      _ => ImageUploadResult.failedByUnknown
    };
  }
}
