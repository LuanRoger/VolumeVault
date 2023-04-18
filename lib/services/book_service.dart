import 'dart:convert';

import 'package:volume_vault/models/api_config_params.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/book_search_result.dart';
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

  BookService(
      {required ApiConfigParams apiConfig, required String userAuthToken})
      : _apiConfig = apiConfig {
    _httpModule = HttpModule(fixHeaders: {
      Consts.API_KEY_REQUEST_HEADER: _apiConfig.apiKey,
      Consts.AUTHORIZATION_REQUEST_HEADER: "Bearer $userAuthToken"
    });
  }

  String get _baseUrl =>
      "${_apiConfig.protocol}://${_apiConfig.host}:${_apiConfig.port}/book";
  String get _bookRootUrl => _baseUrl;
  String get _bookGenresUrl => "$_baseUrl/genres";
  String get _bookAndIdUrl => "$_bookRootUrl/"; // + bookId
  String get _searchBookUrl => "$_bookRootUrl/search";

  Future<BookModel?> getUserBookById(int bookId) async {
    HttpResponse response =
        await _httpModule.get(_bookAndIdUrl + bookId.toString());
    if (response.statusCode != HttpCode.OK) return null;

    return BookModel.fromJson(response.body as Map<String, dynamic>);
  }

  Future<UserBookResult?> getUserBook(
      GetUserBookRequest getUserBookRequest) async {
    HttpResponse response =
        await _httpModule.get(_baseUrl, query: getUserBookRequest.forRequest());
    if (response.statusCode != HttpCode.OK) return null;

    UserBookResult userBooks = UserBookResult.fromJson(response.body);

    return userBooks;
  }

  Future<List<String>> getBooksGenres() async {
    HttpResponse response = await _httpModule.get(_bookGenresUrl);
    if (response.statusCode != HttpCode.OK) return List.empty();

    return (response.body as List).map((e) => e as String).toList();
  }

  Future<BookModel?> registerBook(RegisterBookRequest book) async {
    String bookJson = json.encode(book);

    HttpResponse response = await _httpModule.post(_baseUrl, body: bookJson);
    if (response.statusCode != HttpCode.CREATED) return null;
    BookModel registeredBook = BookModel.fromJson(response.body);

    return registeredBook;
  }

  Future<bool> updateBook(int bookId, EditBookRequest newInfosBook) async {
    String bookJson = json.encode(newInfosBook);

    HttpResponse response = await _httpModule
        .put(_bookAndIdUrl + bookId.toString(), body: bookJson);
    if (response.statusCode != HttpCode.OK) return false;

    return true;
  }

  Future<bool> deleteBook(int bookId) async {
    HttpResponse response =
        await _httpModule.delete(_bookAndIdUrl + bookId.toString());

    return response.statusCode == HttpCode.OK;
  }

  Future<List<BookSearchResult>> searchBook(String query) async {
    final response = await _httpModule.get(_searchBookUrl, query: {
      "query": query,
    });
    if (response.statusCode != HttpCode.OK) return List.empty();

    List<BookSearchResult> searchResult = (response.body as List)
        .map((bookJson) => BookSearchResult.fromJson(bookJson))
        .toList();

    return searchResult;
  }
}
