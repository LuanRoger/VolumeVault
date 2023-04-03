import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_vault/app.dart';
import 'package:volume_vault/l10n/l10n.dart';
import 'package:volume_vault/models/enums/theme_brightness.dart';
import 'package:volume_vault/providers/interfaces/graphics_preferences_state.dart';
import 'package:volume_vault/providers/interfaces/localization_preferences_state.dart';
import 'package:volume_vault/providers/interfaces/theme_preferences_state.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/shared/preferences/app_preferences.dart';
import 'package:volume_vault/shared/preferences/models/graphics_preferences.dart';
import 'package:volume_vault/shared/preferences/models/localization_preferences.dart';
import 'package:volume_vault/shared/preferences/models/theme_preferences.dart';
import 'package:volume_vault/shared/preferences/preferences_key.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final appPreferences = loadPreferences(sharedPreferences);

  runApp(
    ProviderScope(overrides: [
      themePreferencesStateProvider.overrideWith((_) {
        final themePrefences = appPreferences.themePreferences;

        return ThemePreferencesState(sharedPreferences,
            themePreferences: themePrefences);
      }),
      graphicsPreferencesStateProvider.overrideWith((_) {
        final graphicsPreferences = appPreferences.graphicsPreferences;

        return GraphicsPreferencesState(sharedPreferences,
            graphicsPreferences: graphicsPreferences);
      }),
      localizationPreferencesStateProvider.overrideWith((_) {
        final localizationPreferences = appPreferences.localizationPreferences;

        return LocalizationPreferencesState(sharedPreferences,
            localizationPreferences: localizationPreferences);
      }),
    ], child: const App()),
  );
}

AppPreferences loadPreferences(SharedPreferences preferences) {
  final themePreferences = ThemePreferences(
      themeBrightnes: ThemeBrightness
          .values[preferences.getInt(PreferencesKey.themeModePrefKey) ?? 0]);
  final graphicsPreferences = GraphicsPreferences(
      lightEffect:
          preferences.getBool(PreferencesKey.lightEffectPrefKey) ?? true);
  final localizationPreferences = LocalizationPreferences(
      localization: L10n.getLocaleFromCode(
          preferences.getInt(PreferencesKey.localizationPrefKey) ?? 0));

  return AppPreferences(
      themePreferences: themePreferences,
      graphicsPreferences: graphicsPreferences,
      localizationPreferences: localizationPreferences);
}
