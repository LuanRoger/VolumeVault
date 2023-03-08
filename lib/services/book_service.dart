import 'dart:convert';

import 'package:volume_vault/models/api_config_params.dart';
import 'package:volume_vault/models/book_model.dart';
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
  String get _bookAndIdUrl => "$_bookRootUrl/"; // + bookId
  String get _searchBookUrl => "$_bookRootUrl/search";

  Future<BookModel?> getUserBookById(int bookId) async {
    HttpResponse response =
        await _httpModule.get(_bookAndIdUrl + bookId.toString());
    if (response.statusCode != HttpCode.OK) return null;

    return BookModel.fromJson(response.body as Map<String, dynamic>);
  }

  Future<UserBookResult> getUserBook(
      GetUserBookRequest getUserBookRequest) async {
    HttpResponse response =
        await _httpModule.get(_baseUrl, query: getUserBookRequest.forRequest());
    final UserBookResult userBooks =
        UserBookResult(books: List.empty(growable: true));
    if (response.statusCode != HttpCode.OK) return userBooks;

    for (Map<String, dynamic> jsonBook in response.body as List) {
      userBooks.books.add(BookModel.fromJson(jsonBook));
    }

    return userBooks;
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

  Future<List<String>> searchBook(String query) async {
    final response = await _httpModule.get(_searchBookUrl, query: {
      "query": query,
    });

    List<String> searchResults =
        (response.body as List).map((e) => e.toString()).toList();

    return searchResults;
  }
}
