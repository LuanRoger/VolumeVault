import 'package:volume_vault/models/api_config_params.dart';
import 'package:volume_vault/models/http_response.dart';
import 'package:volume_vault/models/interfaces/http_module.dart';
import 'package:volume_vault/services/models/book_stats.dart';

import '../shared/consts.dart';

class StatsService {
  late final HttpModule _httpModule;
  final ApiConfigParams _apiConfig;
  final String userIdentifier;

  StatsService(
      {required ApiConfigParams apiConfig, required this.userIdentifier})
      : _apiConfig = apiConfig {
    _httpModule = HttpModule(
        fixHeaders: {Consts.API_KEY_REQUEST_HEADER: _apiConfig.apiKey});
  }

  String get _baseUrl =>
      "${_apiConfig.protocol}://${_apiConfig.host}:${_apiConfig.port}/stats";
  String get _bookStatsUrl => "$_baseUrl/books";

  final String _userIdQueryHeader = "userId";

  Future<BookStats?> getUserBooksStats() async {
    Map<String, String> requestQuery = {_userIdQueryHeader: userIdentifier};
    HttpResponse response =
        await _httpModule.get(_bookStatsUrl, query: requestQuery);
    if (response is! Map) return null;

    return BookStats.fromJson(response.body);
  }
}
