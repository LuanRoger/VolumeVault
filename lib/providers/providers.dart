import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/api_config_params.dart';
import 'package:volume_vault/models/http_code.dart';
import 'package:volume_vault/models/http_response.dart';
import 'package:volume_vault/services/models/sigin_result.dart';
import 'package:volume_vault/providers/interfaces/graphics_preferences_state.dart';
import 'package:volume_vault/providers/interfaces/server_preferences_state.dart';
import 'package:volume_vault/providers/interfaces/theme_preferences_state.dart';
import 'package:volume_vault/services/auth_service.dart';
import 'package:volume_vault/services/book_service.dart';
import 'package:volume_vault/services/models/user_login_request.dart';
import 'package:volume_vault/services/models/user_sigin_request.dart';
import 'package:volume_vault/shared/preferences/app_preferences.dart';
import 'package:volume_vault/shared/preferences/models/graphics_preferences.dart';
import 'package:volume_vault/shared/preferences/models/server_preferences.dart';
import 'package:volume_vault/shared/preferences/models/theme_preferences.dart';
import 'package:volume_vault/shared/storage/app_storage.dart';
import 'package:volume_vault/shared/storage/models/user_session.dart';
import 'package:volume_vault/shared/utils/env_vars.dart';

final apiParamsProvider = Provider<ApiConfigParams>((_) => ApiConfigParams(
    apiKey: EnvVars.apiKey,
    protocol: EnvVars.apiProtocol,
    host: EnvVars.apiHost,
    port: EnvVars.apiPort));

final ChangeNotifierProvider<AppPreferences> appPreferencesProvider =
    ChangeNotifierProvider<AppPreferences>((_) => throw UnimplementedError());
final ChangeNotifierProvider<AppStorage> appStorageProvider =
    ChangeNotifierProvider<AppStorage>((_) => throw UnimplementedError());

//Just to watch the [ChangeNotifierProvider<AppPreferences>] and be watched/readed by
// the [ConsumerWidget]. If you want to change some value, do it in the [appPreferencesProvider]
final themePreferencesStateProvider =
    StateNotifierProvider<ThemePreferencesState, ThemePreferences>((ref) {
  final themePreferences = ref.watch(
    appPreferencesProvider.select((value) => value.themePreferences),
  );

  return ThemePreferencesState(themePreferences: themePreferences);
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
  final serverPreferences = ref.watch(
    appPreferencesProvider.select((value) => value.serverPreferences),
  );

  return ServerPreferencesState(serverPreferences: serverPreferences);
});
final Provider<UserSession> userSessionProvider = Provider<UserSession>((ref) {
  final userSession = ref.watch(
    appStorageProvider.select((value) => value.userSession),
  );

  return userSession;
});

final bookServiceProvider = Provider<BookService>((ref) {
  final apiParams = ref.watch(apiParamsProvider);
  final userSession = ref.watch(userSessionProvider);

  BookService bookService =
      BookService(apiConfig: apiParams, userAuthToken: userSession.token);
  return bookService;
});
final authServiceProvider = Provider<AuthService>((ref) {
  final apiParams = ref.watch(apiParamsProvider);

  AuthService authService = AuthService(apiConfig: apiParams);
  return authService;
});
