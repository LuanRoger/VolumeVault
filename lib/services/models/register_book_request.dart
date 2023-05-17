import 'package:volume_vault/models/enums/read_status.dart';

class RegisterBookRequest {
  String title;
  String author;
  String isbn;
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
  DateTime createdAt;
  DateTime lastModification;

  RegisterBookRequest({
    required this.title,
    required this.author,
    required this.isbn,
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
    required this.createdAt,
    required this.lastModification,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "isbn": isbn,
        if (publicationYear != null) "publicationYear": publicationYear,
        if (publisher != null) "publisher": publisher,
        if (edition != null) "edition": edition,
        if (pagesNumber != null) "pagesNumber": pagesNumber,
        if (genre != null) "genre": genre!.toList(),
        if (format != null) "format": format,
        if (observation != null) "observation": observation,
        if (synopsis != null) "synopsis": synopsis,
        if (coverLink != null) "coverLink": coverLink,
        if (buyLink != null) "buyLink": buyLink,
        if (readStatus != null) "readStatus": readStatus!.index,
        if (readStartDay != null)
          "readStartDay": readStartDay!.toUtc().toIso8601String(),
        if (readEndDay != null)
          "readEndDay": readEndDay!.toUtc().toIso8601String(),
        if (tags != null) "tags": tags!.toList(),
        "createdAt": createdAt.toUtc().toIso8601String(),
        "lastModification": lastModification.toUtc().toIso8601String(),
      };
}
