import 'package:volume_vault/models/enums/book_format.dart';
import 'package:volume_vault/models/enums/read_status.dart';
import "package:volume_vault/models/qr_sharable.dart";
import 'package:volume_vault/models/user_info_model.dart';

class BookModel implements QrSharable {
  String id;
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

  @override
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
        json["id"] as String,
        json["title"] as String,
        json["author"] as String,
        json["isbn"] as String,
        publicationYear: json["publicationYear"] as int?,
        publisher: json["publisher"] as String?,
        edition: json["edition"] as int?,
        pagesNumber: json["pagesNumber"] as int?,
        genre: json["genre"] != null
            ? (json["genre"] as List).map((e) => e as String).toSet()
            : null,
        format: json["format"] != null
            ? BookFormat.values[json["format"] as int]
            : null,
        observation: json["observation"] as String?,
        synopsis: json["synopsis"] as String?,
        coverLink: json["coverLink"] as String?,
        buyLink: json["buyLink"] as String?,
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
            ? (json["tags"] as List).map((e) => e as String).toSet()
            : null,
        createdAt: DateTime.parse(json["createdAt"] as String),
        lastModification: DateTime.parse(json["lastModification"] as String),
        owner: UserInfoModel.fromJson(json["owner"] as Map<String, dynamic>),
      );
}
