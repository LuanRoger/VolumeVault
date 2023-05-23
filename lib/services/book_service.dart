import 'dart:convert';

import 'package:volume_vault/models/api_config_params.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/book_sort_option.dart';
import 'package:volume_vault/models/http_code.dart';
import 'package:volume_vault/models/http_response.dart';
import 'package:volume_vault/models/interfaces/http_module.dart';
import 'package:volume_vault/services/models/edit_book_request.dart';
import 'package:volume_vault/services/models/get_user_book_request.dart';
import 'package:volume_vault/services/models/register_book_request.dart';
import 'package:volume_vault/services/models/user_book_result.dart';
import 'package:volume_vault/shared/consts.dart';

class BookService {
  late final HttpModule _httpModule;
  final ApiConfigParams _apiConfig;
  final String userIdentifier;

  BookService(
      {required ApiConfigParams apiConfig, required this.userIdentifier})
      : _apiConfig = apiConfig {
    _httpModule = HttpModule(fixHeaders: {
      Consts.API_KEY_REQUEST_HEADER: _apiConfig.apiKey,
    });
  }

  String get _baseUrl =>
      "${_apiConfig.protocol}://${_apiConfig.host}:${_apiConfig.port}/book";
  String get _bookRootUrl => _baseUrl;
  String get _bookGenresUrl => "$_baseUrl/genres";
  String get _bookAndIdUrl => "$_bookRootUrl/"; // + bookId
  String get _searchBookUrl => "$_bookRootUrl/search";

  final String _userIdQueryHeader = "userId";

  Future<BookModel?> getUserBookById(int bookId) async {
    Map<String, String> requestQuery = {_userIdQueryHeader: userIdentifier};

    HttpResponse response = await _httpModule
        .get(_bookAndIdUrl + bookId.toString(), query: requestQuery);
    if (response.statusCode != HttpCode.OK) return null;

    return BookModel.fromJson(response.body as Map<String, dynamic>);
  }

  Future<UserBookResult?> getUserBook(GetUserBookRequest getUserBookRequest,
      {BookSortOption? sortOption}) async {
    Map<String, String> requestQuery = Map.of(getUserBookRequest.forRequest());
    requestQuery.addAll({_userIdQueryHeader: userIdentifier});
    if (sortOption != null) requestQuery.addAll(sortOption.forRequest());

    HttpResponse response =
        await _httpModule.get(_baseUrl, query: requestQuery);
    if (response.statusCode != HttpCode.OK) return null;

    UserBookResult userBooks = UserBookResult.fromJson(response.body);

    return userBooks;
  }

  Future<int?> registerBook(RegisterBookRequest book) async {
    String bookJson = json.encode(book);

    Map<String, String> requestQuery = {_userIdQueryHeader: userIdentifier};
    HttpResponse response =
        await _httpModule.post(_baseUrl, body: bookJson, query: requestQuery);
    if (response.statusCode != HttpCode.CREATED) return null;
    int? newBookId = int.tryParse(response.body);

    return newBookId;
  }

  Future<bool> updateBook(int bookId, EditBookRequest newInfosBook) async {
    String bookJson = json.encode(newInfosBook);

    Map<String, String> requestQuery = {_userIdQueryHeader: userIdentifier};
    HttpResponse response = await _httpModule.put(
        _bookAndIdUrl + bookId.toString(),
        body: bookJson,
        query: requestQuery);
    if (response.statusCode != HttpCode.OK) return false;

    return true;
  }

  Future<bool> deleteBook(int bookId) async {
    Map<String, String> requestQuery = {_userIdQueryHeader: userIdentifier};
    HttpResponse response = await _httpModule
        .delete(_bookAndIdUrl + bookId.toString(), query: requestQuery);

    return response.statusCode == HttpCode.OK;
  }
}
