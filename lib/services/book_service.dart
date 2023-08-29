// ignore_for_file: omit_local_variable_types

import "dart:convert";

import "package:volume_vault/models/api_config_params.dart";
import "package:volume_vault/models/book_model.dart";
import "package:volume_vault/models/books_genres_model.dart";
import "package:volume_vault/models/http_code.dart";
import "package:volume_vault/models/http_response.dart";
import "package:volume_vault/models/interfaces/http_module.dart";
import "package:volume_vault/services/models/edit_book_request.dart";
import "package:volume_vault/services/models/get_user_book_request.dart";
import "package:volume_vault/services/models/register_book_request.dart";
import "package:volume_vault/services/models/user_book_result.dart";
import "package:volume_vault/shared/consts.dart";

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
  //String get _searchBookUrl => "$_bookRootUrl/search";

  final String _userIdQueryHeader = "userId";

  Future<BookModel?> getUserBookById(String bookId) async {
    final requestQuery = {_userIdQueryHeader: userIdentifier};

    final HttpResponse response =
        await _httpModule.get(_bookAndIdUrl + bookId, query: requestQuery);
    if (response.statusCode != HttpCode.ok) return null;

    return BookModel.fromJson(response.body as Map<String, dynamic>);
  }

  Future<UserBookResult?> getUserBook(
      GetUserBookRequest getUserBookRequest) async {
    final requestQuery = getUserBookRequest.toJson();
    requestQuery[_userIdQueryHeader] = userIdentifier;

    final HttpResponse response =
        await _httpModule.get(_baseUrl, query: requestQuery);
    if (response.statusCode != HttpCode.ok && response.body is! Map) {
      return null;
    }

    final UserBookResult userBooks =
        UserBookResult.fromJson(response.body as Map<String, dynamic>);

    return userBooks;
  }

  Future<String?> registerBook(RegisterBookRequest book) async {
    final String bookJson = json.encode(book);

    final requestQuery = {_userIdQueryHeader: userIdentifier};
    final HttpResponse response =
        await _httpModule.post(_baseUrl, body: bookJson, query: requestQuery);
    if (response.statusCode != HttpCode.created || response.body == null) {
      return null;
    }

    return response.body as String;
  }

  Future<bool> updateBook(String bookId, EditBookRequest newInfosBook) async {
    final String bookJson = json.encode(newInfosBook);

    final requestQuery = {_userIdQueryHeader: userIdentifier};
    final HttpResponse response = await _httpModule.put(_bookAndIdUrl + bookId,
        body: bookJson, query: requestQuery);

    return response.statusCode == HttpCode.ok;
  }

  Future<bool> deleteBook(String bookId) async {
    final requestQuery = {_userIdQueryHeader: userIdentifier};
    final HttpResponse response =
        await _httpModule.delete(_bookAndIdUrl + bookId, query: requestQuery);

    return response.statusCode == HttpCode.ok;
  }

  Future<BooksGenresModel?> getBooksGenres() async {
    final requestQuery = {_userIdQueryHeader: userIdentifier};
    final HttpResponse response =
        await _httpModule.get(_bookGenresUrl, query: requestQuery);
    if (response.statusCode != HttpCode.ok || response.body is! Map) {
      return null;
    }

    final booksGenres =
        BooksGenresModel.fromJson(response.body as Map<String, dynamic>);
    return booksGenres;
  }
}
