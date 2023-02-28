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
  Set<String>? tags;
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "author": author,
        "isbn": isbn,
        "publicationYear": publicationYear,
        "publisher": publisher,
        "edition": edition,
        "pagesNumber": pagesNumber,
        "genre": genre,
        "format": format?.index,
        "observation": observation,
        "synopsis": synopsis,
        "coverLink": coverLink,
        "buyLink": buyLink,
        "readed": readed,
        "tags": tags?.toList(),
        "createdAt": createdAt.toIso8601String(),
        "lastModification": lastModification.toIso8601String(),
        "owner": owner.toJson(),
      };
  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
        json["id"] as int,
        json["title"] as String,
        json["author"] as String,
        json["isbn"] as String,
        publicationYear: json["publicationYear"] as int?,
        publisher: json["publisher"] as String?,
        edition: json["edition"] as int?,
        pagesNumber: json["pagesNumber"] as int?,
        genre: json["genre"] as String?,
        format: json["format"] != null
            ? BookFormat.values[json["format"] as int]
            : null,
        observation: json["observation"] as String?,
        synopsis: json["synopsis"] as String?,
        coverLink: json["coverLink"] as String?,
        buyLink: json["buyLink"] as String?,
        readed: json["readed"] as bool?,
        tags: json["tags"] != null
            ? (json["tags"] as List<String>).toSet()
            : null,
        createdAt: DateTime.parse(json["createdAt"] as String),
        lastModification: DateTime.parse(json["lastModification"] as String),
        owner: UserInfoModel.fromJson(json["owner"] as Map<String, dynamic>),
      );
}
