import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_vault/app.dart';
import 'package:volume_vault/models/enums/theme_brightness.dart';
import 'package:volume_vault/providers/interfaces/graphics_preferences_state.dart';
import 'package:volume_vault/providers/interfaces/theme_preferences_state.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/shared/preferences/app_preferences.dart';
import 'package:volume_vault/shared/preferences/models/graphics_preferences.dart';
import 'package:volume_vault/shared/preferences/models/theme_preferences.dart';
import 'package:volume_vault/shared/preferences/preferences_key.dart';
import 'package:volume_vault/shared/utils/platform_utils.dart';

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
    ], child: const App()),
  );

  if (PlatformUtils.isDesktop) {
    doWhenWindowReady(() {
      const initialSize = Size(1200, 600);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.title = "Volume Vault";
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
  }
}

AppPreferences loadPreferences(SharedPreferences preferences) {
  final themePreferences = ThemePreferences(
      themeBrightnes: ThemeBrightness
          .values[preferences.getInt(PreferencesKey.themeModePrefKey) ?? 0]);
  final graphicsPreferences = GraphicsPreferences(
      lightEffect:
          preferences.getBool(PreferencesKey.lightEffectPrefKey) ?? true);

  return AppPreferences(
      themePreferences: themePreferences,
      graphicsPreferences: graphicsPreferences);
}
