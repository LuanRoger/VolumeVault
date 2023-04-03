import 'package:flutter/foundation.dart';
import 'package:volume_vault/shared/preferences/models/graphics_preferences.dart';
import 'package:volume_vault/shared/preferences/models/localization_preferences.dart';
import 'package:volume_vault/shared/preferences/models/theme_preferences.dart';

class AppPreferences extends ChangeNotifier {
  final ThemePreferences themePreferences;
  final GraphicsPreferences graphicsPreferences;
  final LocalizationPreferences localizationPreferences;

  AppPreferences(
      {required this.themePreferences,
      required this.graphicsPreferences,
      required this.localizationPreferences});
}
