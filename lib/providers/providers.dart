import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/providers/interfaces/graphics_preferences_state.dart';
import 'package:volume_vault/providers/interfaces/server_preferences_state.dart';
import 'package:volume_vault/providers/interfaces/theme_preferences_state.dart';
import 'package:volume_vault/shared/preferences/app_preferences.dart';
import 'package:volume_vault/shared/preferences/models/graphics_preferences.dart';
import 'package:volume_vault/shared/preferences/models/server_preferences.dart';
import 'package:volume_vault/shared/preferences/models/theme_preferences.dart';

final ChangeNotifierProvider<AppPreferences> appPreferencesProvider =
    ChangeNotifierProvider<AppPreferences>((ref) => throw UnimplementedError());

//Just to watch the [ChangeNotifierProvider<AppPreferences>] and be watched/readed by
// the [ConsumerWidget]. If you want to change some value, do it in the [appPreferencesProvider]
final themePreferencesStateProvider =
    StateNotifierProvider<ThemePreferencesState, ThemePreferences>((ref) {
  final themePreferences = ref.watch(appPreferencesProvider.select((value) => value.themePreferences),);

  return ThemePreferencesState(
      themePreferences: themePreferences);
});
final graphicsPreferencesStateProvider =
    StateNotifierProvider<GraphicsPreferencesState, GraphicsPreferences>((ref) {
  final graphicsPreferences = ref.watch(
    appPreferencesProvider.select((value) => value.graphicsPreferences),
  );

  return GraphicsPreferencesState(graphicsPreferences: graphicsPreferences);
});
final serverPreferencesStateProvider =
    StateNotifierProvider<ServerPreferencesState, ServerPreferences>((ref) {
  final serverPreferences = ref.watch(appPreferencesProvider.select((value) => value.serverPreferences),);

  return ServerPreferencesState(
      serverPreferences: serverPreferences);
});
