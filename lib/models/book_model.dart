import 'package:volume_vault/models/enums/book_format.dart';
import 'package:volume_vault/models/user_info_model.dart';

class BookModel {
  int id;
  String title;
  String author;
  String isbn;
  int? publicationYear;
  String? publisher;
  int? edition;
  int? pagesNumber;
  String? genre;
  BookFormat? format;
  String? observation;
  String? synopsis;
  String? coverLink;
  String? buyLink;
  bool? readed;
  List<String>? tags;
  DateTime createdAt;
  DateTime lastModification;
  UserInfoModel owner;

  BookModel(this.id, this.title, this.author, this.isbn,
      {this.publicationYear,
      this.publisher,
      this.edition,
      this.pagesNumber,
      this.genre,
      this.format,
      this.observation,
      this.synopsis,
      this.coverLink,
      this.buyLink,
      this.readed,
      this.tags,
      required this.createdAt,
      required this.lastModification,
      required this.owner});
}
