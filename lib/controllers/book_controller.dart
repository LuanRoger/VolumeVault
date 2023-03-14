import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/services/book_service.dart';

class BookController {
  final BookService? _service;

  BookController({required BookService? service}) : _service = service;

  //Return the dialog result and operation result
  Future<bool> deleteBook(int bookId) async {
    if (_service == null) return false;

    return await _service!.deleteBook(bookId);
  }

  //Get the most updated information from an book
  Future<BookModel?> updateBookInfo(int bookId) async {
    if (_service == null) return null;

    return _service!.getUserBookById(bookId);
  }
}
