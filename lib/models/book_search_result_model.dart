import "package:volume_vault/models/enums/book_format.dart";
import "package:volume_vault/models/enums/read_status.dart";

class BookSearchResultModel {
  String id;
  String title;
  String author;
  String isbn;
  int? publicationYear;
  String? publisher;
  int? edition;
  int? pagesNumber;
  List<String>? genre;
  BookFormat? format;
  ReadStatus? readStatus;
  DateTime? readStartDay;
  DateTime? readEndDay;
  List<String>? tags;
  DateTime? createdAt;
  DateTime? lastModification;
  String ownerId;

  BookSearchResultModel({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.ownerId,
    this.publicationYear,
    this.publisher,
    this.edition,
    this.pagesNumber,
    this.genre,
    this.format,
    this.readStatus,
    this.readStartDay,
    this.readEndDay,
    this.tags,
    this.createdAt,
    this.lastModification,
  });

  factory BookSearchResultModel.empty() => BookSearchResultModel(
        id: "",
        title: "",
        author: "",
        isbn: "",
        ownerId: "",
      );

  factory BookSearchResultModel.fromJson(Map<String, dynamic> json) =>
      BookSearchResultModel(
          id: json["id"] as String,
          title: json["title"] as String,
          author: json["author"] as String,
          isbn: json["isbn"] as String,
          publicationYear: json["publicationYear"] as int?,
          publisher: json["publisher"] as String?,
          edition: json["edition"] as int?,
          pagesNumber: json["pagesNumber"] as int?,
          genre: json["genre"] != null
              ? (json["genre"] as List).map((e) => e as String).toList()
              : null,
          format: json["format"] != null
              ? BookFormat.values[json["format"] as int]
              : null,
          readStatus: json["readStatus"] != null
              ? ReadStatus.values[json["readStatus"] as int]
              : null,
          readStartDay: json["readStartDay"] != null
              ? DateTime.parse(json["readStartDay"] as String)
              : null,
          readEndDay: json["readEndDay"] != null
              ? DateTime.parse(json["readEndDay"] as String)
              : null,
          tags: json["tags"] != null
              ? (json["tags"] as List).map((e) => e as String).toList()
              : null,
          createdAt: DateTime.parse(json["createdAt"] as String),
          lastModification: DateTime.parse(json["lastModification"] as String),
          ownerId: json["ownerId"] as String);
}
