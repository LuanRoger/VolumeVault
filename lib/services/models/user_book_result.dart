import 'package:volume_vault/models/book_model.dart';

class UserBookResult {
  final int page;
  final int limitPerPage;
  final int count;
  final List<BookModel> books;

  UserBookResult(
      {required this.books,
      required this.page,
      required this.limitPerPage,
      this.count = 0});

  factory UserBookResult.empty() =>
      UserBookResult(books: List.empty(), page: 0, limitPerPage: 0);

  factory UserBookResult.fromJson(Map<String, dynamic> json) {
    return UserBookResult(
        books:
            (json["books"] as List).map((e) => BookModel.fromJson(e)).toList(),
        page: json["page"] as int,
        limitPerPage: json["limitPerPage"] as int,
        count: json["countInPage"] as int);
  }
}
