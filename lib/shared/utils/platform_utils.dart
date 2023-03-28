import 'dart:io';

class PlatformUtils {
  static bool get isDesktop =>
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  static bool get isMobile =>
      Platform.isAndroid || Platform.isIOS || Platform.isFuchsia;
}
