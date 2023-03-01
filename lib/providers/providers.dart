import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_vault/models/api_config_params.dart';
import 'package:volume_vault/providers/interfaces/graphics_preferences_state.dart';
import 'package:volume_vault/providers/interfaces/server_config_notifier.dart';
import 'package:volume_vault/providers/interfaces/theme_preferences_state.dart';
import 'package:volume_vault/providers/interfaces/user_session_notifier.dart';
import 'package:volume_vault/services/auth_service.dart';
import 'package:volume_vault/services/utils_service.dart';
import 'package:volume_vault/shared/preferences/models/graphics_preferences.dart';
import 'package:volume_vault/shared/preferences/models/theme_preferences.dart';
import 'package:volume_vault/shared/storage/models/server_config.dart';
import 'package:volume_vault/shared/storage/models/user_session.dart';

final userSessionNotifierProvider =
    AsyncNotifierProvider<UserSessionNotifier, UserSession>(
        UserSessionNotifier.new);
final serverConfigNotifierProvider =
    AsyncNotifierProvider<ServerConfigNotifier, ServerConfig>(
        ServerConfigNotifier.new);

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});
final themePreferencesStateProvider =
    StateNotifierProvider<ThemePreferencesState, ThemePreferences>(
        (_) => throw UnimplementedError());
final graphicsPreferencesStateProvider =
    StateNotifierProvider<GraphicsPreferencesState, GraphicsPreferences>(
        (_) => throw UnimplementedError());

final authServiceProvider = FutureProvider<AuthService>((ref) async {
  final serverConfig = await ref.watch(serverConfigNotifierProvider.future);

  return AuthService(
    apiConfig: ApiConfigParams(
        host: serverConfig.serverHost,
        port: serverConfig.serverPort,
        apiKey: serverConfig.serverApiKey,
        protocol: serverConfig.serverProtocol),
  );
});
final utilsServiceProvider = FutureProvider<UtilsService>((ref) async {
  final serverConfig = await ref.watch(serverConfigNotifierProvider.future);

  return UtilsService(
    apiConfigParams: ApiConfigParams(
        host: serverConfig.serverHost,
        port: serverConfig.serverPort,
        apiKey: serverConfig.serverApiKey,
        protocol: serverConfig.serverProtocol),
  );
});
