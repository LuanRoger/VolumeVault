import "package:volume_vault/models/book_search_result.dart";
import "package:volume_vault/services/book_search_service.dart";
import "package:volume_vault/services/models/book_search_request.dart";

class BookSearchController {
  final BookSearchService? _service;

  BookSearchController({BookSearchService? service}) : _service = service;

  Future<BookSearchResult?> searchForBook(BookSearchRequest requestParams) {
    if (_service == null) return Future.value();

    return _service!.searchBook(requestParams);
  }
}
