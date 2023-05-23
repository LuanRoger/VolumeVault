import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_vault/controllers/book_controller.dart';
import 'package:volume_vault/controllers/book_search_controller.dart';
import 'package:volume_vault/controllers/stats_controller.dart';
import 'package:volume_vault/models/api_config_params.dart';
import 'package:volume_vault/models/search_api_config_params.dart';
import 'package:volume_vault/models/user_session.dart';
import 'package:volume_vault/providers/interfaces/graphics_preferences_state.dart';
import 'package:volume_vault/providers/interfaces/localization_preferences_state.dart';
import 'package:volume_vault/providers/interfaces/server_config_notifier.dart';
import 'package:volume_vault/providers/interfaces/theme_preferences_state.dart';
import 'package:volume_vault/providers/interfaces/user_session_state.dart';
import 'package:volume_vault/services/book_search_service.dart';
import 'package:volume_vault/services/book_service.dart';
import 'package:volume_vault/services/stats_service.dart';
import 'package:volume_vault/shared/preferences/models/graphics_preferences.dart';
import 'package:volume_vault/shared/preferences/models/localization_preferences.dart';
import 'package:volume_vault/shared/preferences/models/theme_preferences.dart';
import 'package:volume_vault/shared/storage/models/server_config.dart';

part '../controllers/controller_providers.dart';

final userSessionAuthProvider =
    NotifierProvider<UserSessionState, UserSession?>(UserSessionState.new);
final serverConfigNotifierProvider =
    AsyncNotifierProvider<ServerConfigNotifier, ServerConfig>(
        ServerConfigNotifier.new);
final apiParamsProvider = FutureProvider<ApiConfigParams>((ref) async {
  final serverConfig = await ref.watch(serverConfigNotifierProvider.future);

  return ApiConfigParams(
      host: serverConfig.serverHost,
      port: serverConfig.serverPort,
      apiKey: serverConfig.serverApiKey,
      protocol: serverConfig.serverProtocol);
});
final searchApiParamsProvider =
    FutureProvider<SearchApiConfigParams>((ref) async {
  final serverConfig = await ref.watch(serverConfigNotifierProvider.future);

  int intPort = int.parse(serverConfig.searchServerPort);
  return SearchApiConfigParams(
      host: serverConfig.searchServerHost,
      port: intPort,
      apiKey: serverConfig.searchServerApiKey,
      protocol: serverConfig.searchServerProtocol);
});

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
final localizationPreferencesStateProvider = StateNotifierProvider<
    LocalizationPreferencesState,
    LocalizationPreferences>((_) => throw UnimplementedError());

final _bookServiceProvider = FutureProvider<BookService?>((ref) async {
  final apiConfig = await ref.watch(apiParamsProvider.future);
  final userSession = ref.watch(userSessionAuthProvider);

  if (userSession == null) return null;

  return BookService(
    apiConfig: apiConfig,
    userIdentifier: userSession.uid,
  );
});
final _bookSearchServiceProvider =
    FutureProvider<BookSearchService?>((ref) async {
  final apiConfig = await ref.watch(searchApiParamsProvider.future);
  final userSession = ref.watch(userSessionAuthProvider);

  if (userSession == null) return null;

  return BookSearchService(
    apiConfig: apiConfig,
    userIdentifier: userSession.uid,
  );
});
final _statsServiceProvider = FutureProvider<StatsService?>((ref) async {
  final apiConfig = await ref.watch(apiParamsProvider.future);
  final userSession = ref.watch(userSessionAuthProvider);
  if (userSession == null) return null;

  return StatsService(
    apiConfig: apiConfig,
    userIdentifier: userSession.uid,
  );
});
