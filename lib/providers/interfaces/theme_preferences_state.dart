import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/enums/theme_brightness.dart';
import 'package:volume_vault/shared/preferences/models/theme_preferences.dart';

class ThemePreferencesState extends StateNotifier<ThemePreferences> {
  ThemePreferencesState({ThemePreferences? themePreferences})
      : super(
            themePreferences ?? const ThemePreferences(themeBrightnes: ThemeBrightness.LIGHT));
}
