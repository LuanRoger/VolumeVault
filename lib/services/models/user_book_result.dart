import 'package:volume_vault/models/book_model.dart';

class UserBookResult {
  List<BookModel> books;

  UserBookResult({required this.books});

  factory UserBookResult.empty() => UserBookResult(books: List.empty());
}
