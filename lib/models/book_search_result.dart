import 'package:volume_vault/models/book_search_result_model.dart';

class BookSearchResult {
  final int count;
  final Duration searchElapsedTime;
  final List<BookSearchResultModel> results;

  BookSearchResult(
      {required this.count,
      required this.searchElapsedTime,
      required this.results});

  factory BookSearchResult.fromJson(Map<String, dynamic> json) =>
      BookSearchResult(
          count: json["count"],
          searchElapsedTime: Duration(milliseconds: json["searchElapsedTime"]),
          results: (json["results"] as List)
              .map((e) => BookSearchResultModel.fromJson(e))
              .toList());
}
