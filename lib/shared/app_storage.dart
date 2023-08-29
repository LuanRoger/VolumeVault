// ignore_for_file: avoid_slow_async_io

import "dart:io";

import "package:path/path.dart" as path;
import "package:path_provider/path_provider.dart";

class AppStorage {
  static Future<String> getAppExternalStoragePath() async {
    final directoryPath = await getExternalStorageDirectory();
    if (directoryPath == null) return "";

    final exists = await directoryPath.exists();
    if (!exists) {
      await directoryPath.create();
    }

    return directoryPath.path;
  }

  static Future<Directory> ensureCreatedAppDirectory(
      String directoryPath) async {
    final appExternalStoragePath = await getAppExternalStoragePath();
    final directory =
        Directory(path.join(appExternalStoragePath, directoryPath));

    final exists = await directory.exists();
    if (!exists) {
      await directory.create();
    }

    return directory;
  }

  static Future<String> getAppExternalImageStoragePath() async {
    final appExternalStoragePath = await getAppExternalStoragePath();
    final appImagePath = path.join(appExternalStoragePath, "images");
    final appImageDirectory = Directory(appImagePath);

    final exists = await appImageDirectory.exists();
    if (!exists) {
      await appImageDirectory.create();
    }

    return appImageDirectory.path;
  }
}
