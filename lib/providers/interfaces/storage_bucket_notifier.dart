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

    final inAppImagePath = path.join(
        await AppStorage.getAppExternalImageStoragePath(),
        UserStorageBucket.profileImageName);
    final inAppProfileImageFile = File(inAppImagePath);
    if (await inAppProfileImageFile.exists()) {
      return inAppProfileImageFile;
    }

    final storageBucketRef =
        FirebaseStorage.instance.ref(storageBucket!.profileImageRef);
    final profileImageRef =
        storageBucketRef.child(UserStorageBucket.profileImageName);

    final writeTask = profileImageRef.writeToFile(inAppProfileImageFile);
    await writeTask;

    if (writeTask.snapshot.state != TaskState.success) {
      return null;
    }

    return File(inAppProfileImageFile.path);
  }

  Future<File?> getProfileBackgroundImageFromBucket() async {
    if (!_isLogged) return null;

    final inAppImagePath = await AppStorage.getAppExternalImageStoragePath();
    final inAppProfileBackgroundImageFile = File(
        path.join(inAppImagePath, UserStorageBucket.profileBackgroundName));
    if (await inAppProfileBackgroundImageFile.exists()) {
      return inAppProfileBackgroundImageFile;
    }

    final storageBucketRef =
        FirebaseStorage.instance.ref(storageBucket!.profileImageRef);
    final profileBackgroundImageRef =
        storageBucketRef.child(UserStorageBucket.profileBackgroundName);

    final writeTask =
        profileBackgroundImageRef.writeToFile(inAppProfileBackgroundImageFile);
    await writeTask;

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
        FirebaseStorage.instance.ref(storageBucket!.profileImageRef);
    UploadTask uploadTask = storageBucketRef.putFile(imageFile);
    await uploadTask;

    final inAppImagePath = await AppStorage.getAppExternalImageStoragePath();
    final inAppProfileImagePath =
        path.join(inAppImagePath, UserStorageBucket.profileImageName);
    imageFile.copy(inAppProfileImagePath);

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
        FirebaseStorage.instance.ref(storageBucket!.profileImageRef);
    UploadTask uploadTask = storageBucketRef.putFile(imageFile);
    await uploadTask;

    final inAppBackgroundImagePath =
        await AppStorage.getAppExternalImageStoragePath();
    final inAppProfileBackgroundImagePath = path.join(
        inAppBackgroundImagePath, UserStorageBucket.profileBackgroundName);
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
