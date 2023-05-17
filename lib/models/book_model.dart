import 'package:volume_vault/models/enums/book_format.dart';
import 'package:volume_vault/models/enums/read_status.dart';
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
  Set<String>? genre;
  BookFormat? format;
  String? observation;
  String? synopsis;
  String? coverLink;
  String? buyLink;
  ReadStatus? readStatus;
  DateTime? readStartDay;
  DateTime? readEndDay;
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
      this.readStatus,
      this.readStartDay,
      this.readEndDay,
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
        "genre": genre?.toList(),
        "format": format?.index,
        "observation": observation,
        "synopsis": synopsis,
        "coverLink": coverLink,
        "buyLink": buyLink,
        "readStatus": readStatus?.index,
        "readStartDay": readStartDay?.toIso8601String(),
        "readEndDay": readEndDay?.toIso8601String(),
        "tags": tags?.toList(),
        "createdAt": createdAt.toIso8601String(),
        "lastModification": lastModification.toIso8601String(),
        "owner": owner.toJson(),
      };
  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
        json["id"],
        json["title"],
        json["author"],
        json["isbn"],
        publicationYear: json["publicationYear"],
        publisher: json["publisher"],
        edition: json["edition"],
        pagesNumber: json["pagesNumber"],
        genre: json["genre"] != null
            ? (json["genre"] as List).map((e) => e as String).toSet()
            : null,
        format:
            json["format"] != null ? BookFormat.values[json["format"]] : null,
        observation: json["observation"],
        synopsis: json["synopsis"],
        coverLink: json["coverLink"],
        buyLink: json["buyLink"],
        readStatus: json["readStatus"] != null
            ? ReadStatus.values[json["readStatus"]]
            : null,
        readStartDay: json["readStartDay"] != null
            ? DateTime.parse(json["readStartDay"])
            : null,
        readEndDay: json["readEndDay"] != null
            ? DateTime.parse(json["readEndDay"])
            : null,
        tags: json["tags"] != null
            ? (json["tags"] as List).map((e) => e as String).toSet()
            : null,
        createdAt: DateTime.parse(json["createdAt"]),
        lastModification: DateTime.parse(json["lastModification"]),
        owner: UserInfoModel.fromJson(json["owner"]),
      );
}
