import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class AppStorage {
  static Future<String> getAppExternalStoragePath() async {
    final Directory? directoryPath = await getExternalStorageDirectory();
    if (directoryPath == null) return "";

    final exists = await directoryPath.exists();
    if (!exists) {
      directoryPath.create();
    }

    return directoryPath.path;
  }

  static Future<Directory> ensureCreatedAppDirectory(
      String directoryPath) async {
    final String appExternalStoragePath = await getAppExternalStoragePath();
    final directory = Directory(path.join(appExternalStoragePath, directoryPath));
    
    final exists = await directory.exists();
    if (!exists) {
      directory.create();
    }

    return directory;
  }

  static Future<String> getAppExternalImageStoragePath() async {
    final String appExternalStoragePath = await getAppExternalStoragePath();
    final appImagePath = path.join(appExternalStoragePath, "images");
    final appImageDirectory = Directory(appImagePath);

    final exists = await appImageDirectory.exists();
    if (!exists) {
      appImageDirectory.create();
    }

    return appImageDirectory.path;
  }
}
