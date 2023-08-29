import "package:freezed_annotation/freezed_annotation.dart";
import "package:volume_vault/models/enums/theme_brightness.dart";

part "theme_preferences.freezed.dart";

@freezed
class ThemePreferences with _$ThemePreferences {
  const factory ThemePreferences({required ThemeBrightness themeBrightnes}) =
      _ThemePreferences;
}
