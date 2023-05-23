import 'package:volume_vault/models/book_search_result.dart';
import 'package:volume_vault/models/http_code.dart';
import 'package:volume_vault/models/http_response.dart';
import 'package:volume_vault/models/interfaces/http_module.dart';
import 'package:volume_vault/models/search_api_config_params.dart';
import 'package:volume_vault/services/models/book_search_request.dart';
import 'package:volume_vault/shared/consts.dart';

class BookSearchService {
  late final HttpModule _httpModule;
  final SearchApiConfigParams _apiConfig;
  final String userIdentifier;

  BookSearchService(
      {required SearchApiConfigParams apiConfig, required this.userIdentifier})
      : _apiConfig = apiConfig {
    _httpModule = HttpModule(fixHeaders: {
      Consts.API_KEY_REQUEST_HEADER: _apiConfig.apiKey,
    });
  }

  String get _baseUrl => "${_apiConfig.protocol}://${_apiConfig.host}:${_apiConfig.port}/search";
  String get _searchBookUrl => _baseUrl;

  Future<BookSearchResult?> searchBook(BookSearchRequest requestParams) async {
    Map<String, dynamic> queryParams = {
      "userId": userIdentifier,
      "query": requestParams.query,
      "limitPerSection": requestParams.limitPerPage
    };

    HttpResponse response =
        await _httpModule.get(_searchBookUrl, query: queryParams);
    if (response.statusCode != HttpCode.OK) return null;

    BookSearchResult bookSearchResult =
        BookSearchResult.fromJson(response.body);

    return bookSearchResult;
  }
}
