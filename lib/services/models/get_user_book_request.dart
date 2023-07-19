import "package:volume_vault/models/book_result_limiter.dart";
import "package:volume_vault/models/book_sort_option.dart";

class GetUserBookRequest {
  int page;
  final int limitPerPage;
  final BookSortOption? sortOptions;
  final BookResultLimiter? resultLimiter;

  GetUserBookRequest(
      {required this.page,
      this.limitPerPage = 10,
      this.sortOptions,
      this.resultLimiter});

  Map<String, dynamic> toJson() => {
        "page": page,
        "limitPerPage": limitPerPage,
        if (sortOptions != null && sortOptions!.sort != null)
          "sort": sortOptions!.sort!.index,
        if (sortOptions != null && sortOptions!.ascending)
          "ascending": sortOptions?.ascending ?? true,
        if (resultLimiter != null && resultLimiter!.format != null)
          "bookFormat": resultLimiter!.format!.index
      };

  GetUserBookRequest copyWith(
      {int? page,
      int? limitPerPage,
      BookSortOption? sortOptions,
      BookResultLimiter? resultLimiter}) {
    return GetUserBookRequest(
      page: page ?? this.page,
      limitPerPage: limitPerPage ?? this.limitPerPage,
      sortOptions: sortOptions ?? this.sortOptions,
      resultLimiter: resultLimiter ?? this.resultLimiter,
    );
  }
}
