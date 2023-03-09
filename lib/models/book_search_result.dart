import 'package:volume_vault/models/enums/book_format.dart';

class BookSearchResult {
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
  bool? readed;
  Set<String>? tags;
  DateTime createdAt;
  DateTime lastModification;
  int ownerId;

  BookSearchResult(
      this.id,
      this.title,
      this.author,
      this.isbn,
      {this.publicationYear,
      this.publisher,
      this.edition,
      this.pagesNumber,
      this.genre,
      this.format,
      this.readed,
      this.tags,
      required this.createdAt,
      required this.lastModification,
      required this.ownerId});

  factory BookSearchResult.fromJson(Map<String, dynamic> json) => BookSearchResult(
      json["id"],
      json["title"],
      json["author"],
      json["isbn"],
      publicationYear: json["publicationYear"],
      publisher: json["publisher"],
      edition: json["edition"],
      pagesNumber: json["pagesNumber"],
      genre: json["genre"],
      format: json["format"] != null ? BookFormat.values[json["format"]] : null,
      readed: json["readed"],
      tags: json["tags"] != null ? 
      (json["tags"] as List).map((e) => e as String).toSet()
       : null,
      createdAt: DateTime.parse(json["createdAt"]),
      lastModification: DateTime.parse(json["lastModification"]),
      ownerId: json["ownerId"]);
}