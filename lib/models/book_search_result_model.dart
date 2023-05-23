import 'package:volume_vault/models/enums/book_format.dart';
import 'package:volume_vault/models/enums/read_status.dart';

class BookSearchResultModel {
  int id;
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

  BookSearchResultModel(
      {required this.id,
      required this.title,
      required this.author,
      required this.isbn,
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
      required this.ownerId});

  factory BookSearchResultModel.empty() => BookSearchResultModel(
      id: -1,
      title: "",
      author: "",
      isbn: "",
      ownerId: "",
      publicationYear: null,
      publisher: null,
      edition: null,
      pagesNumber: null,
      genre: null,
      format: null,
      readStatus: null,
      readStartDay: null,
      readEndDay: null,
      tags: null,
      createdAt: null,
      lastModification: null);

  factory BookSearchResultModel.fromJson(Map<String, dynamic> json) =>
      BookSearchResultModel(
          id: json["id"],
          title: json["title"],
          author: json["author"],
          isbn: json["isbn"],
          publicationYear: json["publicationYear"],
          publisher: json["publisher"],
          edition: json["edition"],
          pagesNumber: json["pagesNumber"],
          genre: json["genre"] != null ? (json["genre"] as List).map((e) => e as String).toList() : null,
          format: json["format"] != null ? BookFormat.values[json["format"]] : null,
          readStatus: json["readStatus"] != null
            ? ReadStatus.values[json["readStatus"]]
            : null,
        readStartDay: json["readStartDay"] != null
            ? DateTime.parse(json["readStartDay"])  
            : null,
        readEndDay: json["readEndDay"] != null
            ? DateTime.parse(json["readEndDay"])
            : null,
          tags: json["tags"] != null ? (json["tags"] as List).map((e) => e as String).toList() : null,
          createdAt: DateTime.parse(json["createdAt"]),
        lastModification: DateTime.parse(json["lastModification"]),
          ownerId: json["ownerId"]);
}
