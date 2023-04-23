import 'package:volume_vault/models/api_config_params.dart';
import 'package:volume_vault/models/http_response.dart';
import 'package:volume_vault/models/interfaces/http_module.dart';
import 'package:volume_vault/services/models/book_stats.dart';

import '../shared/consts.dart';

class StatsService {
  late final HttpModule _httpModule;
  final ApiConfigParams _apiConfig;

  StatsService(
      {required ApiConfigParams apiConfig, required String userAuthToken})
      : _apiConfig = apiConfig {
    _httpModule = HttpModule(fixHeaders: {
      Consts.API_KEY_REQUEST_HEADER: _apiConfig.apiKey,
      Consts.AUTHORIZATION_REQUEST_HEADER: "Bearer $userAuthToken"
    });
  }

  String get _baseUrl =>
      "${_apiConfig.protocol}://${_apiConfig.host}:${_apiConfig.port}/stats";
  String get _bookStatsUrl => "$_baseUrl/books";

  Future<BookStats> getUserBooksStats() async {
    HttpResponse response = await _httpModule.get(_bookStatsUrl);

    return BookStats.fromJson(response.body);
  }
}
