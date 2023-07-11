import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/book_sort_option.dart';
import "package:volume_vault/models/books_genres_model.dart";
import 'package:volume_vault/services/book_service.dart';
import 'package:volume_vault/services/models/edit_book_request.dart';
import 'package:volume_vault/services/models/get_user_book_request.dart';
import 'package:volume_vault/services/models/register_book_request.dart';
import 'package:volume_vault/services/models/user_book_result.dart';

class BookController {
  final BookService? _service;

  BookController({required BookService? service}) : _service = service;

  Future<String?> registerBook(RegisterBookRequest request) async {
    if (_service == null) return null;

    return _service!.registerBook(request);
  }

  Future<UserBookResult> fetcherBooks(GetUserBookRequest request) async {
    if (_service == null) return UserBookResult.empty();

    UserBookResult? userBookResult = await _service!.getUserBook(request);
    return userBookResult ?? UserBookResult.empty();
  }

  //Return the dialog result and operation result
  Future<bool> deleteBook(String bookId) async {
    if (_service == null) return false;

    return _service!.deleteBook(bookId);
  }

  Future<UserBookResult> getUserBooks(GetUserBookRequest request) async {
    if (_service == null) return UserBookResult.empty();

    final userBookResult = await _service!.getUserBook(request);

    return userBookResult ?? UserBookResult.empty();
  }

  Future<BookModel?> getBookInfoById(String bookId) async {
    if (_service == null) return null;

    return _service!.getUserBookById(bookId);
  }

  Future<BooksGenresModel?> getBooksGenres() async {
    if (_service == null) return null;

    return _service!.getBooksGenres();
  }

  Future<bool> updateBookInfo(String bookId, EditBookRequest newInfos) async {
    if (_service == null) return false;

    return _service!.updateBook(bookId, newInfos);
  }
}
