import "package:volume_vault/models/enums/book_sort.dart";

class BookSortOption {
  final BookSort? sort;
  final bool ascending;

  BookSortOption({this.sort, this.ascending = true});
}
