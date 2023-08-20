import "package:volume_vault/models/enums/read_status.dart";

class EditBookRequest {
  String? title;
  String? author;
  String? isbn;
  int? publicationYear;
  String? publisher;
  int? edition;
  int? pagesNumber;
  Set<String>? genre;
  int? format;
  String? observation;
  String? synopsis;
  String? coverLink;
  String? buyLink;
  ReadStatus? readStatus;
  DateTime? readStartDay;
  DateTime? readEndDay;
  Set<String>? tags;
  DateTime lastModification;

  EditBookRequest({
    required this.lastModification,
    this.title,
    this.author,
    this.isbn,
    this.publicationYear,
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
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "isbn": isbn,
        "publicationYear": publicationYear,
        "publisher": publisher,
        "edition": edition,
        "pagesNumber": pagesNumber,
        "genre": genre?.toList(),
        "format": format,
        "observation": observation,
        "synopsis": synopsis,
        "coverLink": coverLink,
        "buyLink": buyLink,
        "tags": tags?.toList(),
        "readStatus": readStatus?.index,
        "readStartDay": readStartDay?.toIso8601String(),
        "readEndDay": readEndDay?.toIso8601String(),
        "lastModification": lastModification.toIso8601String(),
      };
}
