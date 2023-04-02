import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_vault/controllers/auth_controller.dart';
import 'package:volume_vault/controllers/book_controller.dart';
import 'package:volume_vault/controllers/utils_controller.dart';
import 'package:volume_vault/models/api_config_params.dart';
import 'package:volume_vault/models/http_code.dart';
import 'package:volume_vault/models/http_response.dart';
import 'package:volume_vault/models/user_info_model.dart';
import 'package:volume_vault/providers/interfaces/graphics_preferences_state.dart';
import 'package:volume_vault/providers/interfaces/localization_preferences_state.dart';
import 'package:volume_vault/providers/interfaces/server_config_notifier.dart';
import 'package:volume_vault/providers/interfaces/theme_preferences_state.dart';
import 'package:volume_vault/providers/interfaces/user_session_notifier.dart';
import 'package:volume_vault/services/auth_service.dart';
import 'package:volume_vault/services/book_service.dart';
import 'package:volume_vault/services/utils_service.dart';
import 'package:volume_vault/shared/preferences/models/graphics_preferences.dart';
import 'package:volume_vault/shared/preferences/models/localization_preferences.dart';
import 'package:volume_vault/shared/preferences/models/theme_preferences.dart';
import 'package:volume_vault/shared/storage/models/server_config.dart';
import 'package:volume_vault/shared/storage/models/user_session.dart';

part '../controllers/controller_providers.dart';

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
final localizationPreferencesStateProvider =
    StateNotifierProvider<LocalizationPreferencesState, LocalizationPreferences>((_) => throw UnimplementedError());

final userInfoProvider = FutureProvider<UserInfoModel?>((ref) async {
  final userSession = await ref.watch(userSessionNotifierProvider.future);
  final authService = await ref.watch(_authServiceProvider.future);

  if (userSession.token.isEmpty) return null;

  final HttpResponse response =
      await authService.getUserInfo(userSession.token);
  if (response.statusCode != HttpCode.OK) return null;

  UserInfoModel userInfo = UserInfoModel.fromJson(response.body);

  return userInfo;
});
final _authServiceProvider = FutureProvider<AuthService>((ref) async {
  final serverConfig = await ref.watch(serverConfigNotifierProvider.future);

  return AuthService(
    apiConfig: ApiConfigParams(
        host: serverConfig.serverHost,
        port: serverConfig.serverPort,
        apiKey: serverConfig.serverApiKey,
        protocol: serverConfig.serverProtocol),
  );
});
final _bookServiceProvider = FutureProvider<BookService?>((ref) async {
  final serverConfig = await ref.watch(serverConfigNotifierProvider.future);
  final userSession = await ref.watch(userSessionNotifierProvider.future);

  if (userSession.token.isEmpty) return null;

  return BookService(
    userAuthToken: userSession.token,
    apiConfig: ApiConfigParams(
        host: serverConfig.serverHost,
        port: serverConfig.serverPort,
        apiKey: serverConfig.serverApiKey,
        protocol: serverConfig.serverProtocol),
  );
});
final _utilsServiceProvider = FutureProvider<UtilsService>((ref) async {
  final serverConfig = await ref.watch(serverConfigNotifierProvider.future);

  return UtilsService(
    apiConfigParams: ApiConfigParams(
        host: serverConfig.serverHost,
        port: serverConfig.serverPort,
        apiKey: serverConfig.serverApiKey,
        protocol: serverConfig.serverProtocol),
  );
});
