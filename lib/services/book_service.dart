import 'dart:convert';

import 'package:volume_vault/models/api_config_params.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/http_code.dart';
import 'package:volume_vault/models/http_response.dart';
import 'package:volume_vault/models/interfaces/http_module.dart';
import 'package:volume_vault/models/update_book_model.dart';
import 'package:volume_vault/services/models/get_user_book_request.dart';
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
  String get _bookUpdateUrl => "$_bookRootUrl/"; // + bookId
  String get _bookDeleteUrl => "$_bookRootUrl/"; // + bookId
  String get _searchBookUrl => "$_bookRootUrl/search";

  //TODO: Made all return [HttpResponse] and implement logic in providers

  Future<UserBookResult> getUserBook(
      GetUserBookRequest getUserBookRequest) async {
    HttpResponse response =
        await _httpModule.get(_baseUrl, query: getUserBookRequest.forRequest());
    final UserBookResult userBooks = UserBookResult(books: List.empty(growable: true));
    if(response.statusCode != HttpCode.OK) return userBooks;

    for (Map<String, dynamic> jsonBook in response.body as List) {
      userBooks.books.add(BookModel.fromJson(jsonBook));
    }

    return userBooks;
  }

  Future<HttpResponse> registerBook(BookModel book) async {
    String bookJson = json.encode(book);

    HttpResponse response = await _httpModule.post(_baseUrl, body: bookJson);

    return response;
    BookModel.fromJson(response.body as Map<String, dynamic>);
  }

  Future<HttpResponse> updateBook(
      int bookId, UpdateBookModel newInfosBook) async {
    String bookJson = json.encode(newInfosBook);

    HttpResponse response =
        await _httpModule.put(_baseUrl + bookId.toString(), body: bookJson);

    return response;
    BookModel.fromJson(response.body as Map<String, dynamic>);
  }

  Future<HttpResponse> deleteBook(int bookId) async {
    HttpResponse response =
        await _httpModule.delete(_bookDeleteUrl + bookId.toString());

    return response;
  }

  Future<String> searchBook(String query) async {
    final response = await _httpModule.get(_searchBookUrl, query: {
      "query": query,
    });

    //TODO: Check response returned infos
    var d = 0;

    return response.body;
  }
}
