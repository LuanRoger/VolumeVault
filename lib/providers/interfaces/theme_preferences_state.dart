import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:volume_vault/models/enums/theme_brightness.dart";
import "package:volume_vault/shared/preferences/models/theme_preferences.dart";
import "package:volume_vault/shared/preferences/preferences_keys.dart";

class ThemePreferencesState extends StateNotifier<ThemePreferences> {
  final SharedPreferences _preferences;

  ThemePreferencesState(this._preferences, {ThemePreferences? themePreferences})
      : super(themePreferences ??
            const ThemePreferences(themeBrightnes: ThemeBrightness.light));

  ThemeBrightness get themeBrightness => state.themeBrightnes;
  set themeBrightness(ThemeBrightness newValue) {
    state = state.copyWith(themeBrightnes: newValue);
    _preferences.setInt(PreferencesKeys.themeModePrefKey, newValue.index);
  }

  void reset() {
    state = const ThemePreferences(themeBrightnes: ThemeBrightness.light);

    _preferences.setInt(
        PreferencesKeys.themeModePrefKey, state.themeBrightnes.index);
  }
}
