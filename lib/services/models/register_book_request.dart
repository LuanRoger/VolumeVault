class RegisterBookRequest {
  String title;
  String author;
  String isbn;
  int? publicationYear;
  String? publisher;
  int? edition;
  int? pagesNumber;
  String? genre;
  int? format;
  String? observation;
  String? synopsis;
  String? coverLink;
  String? buyLink;
  bool? readed;
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
    this.readed,
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
        if (genre != null) "genre": genre,
        if (format != null) "format": format,
        if (observation != null) "observation": observation,
        if (synopsis != null) "synopsis": synopsis,
        if (coverLink != null) "coverLink": coverLink,
        if (buyLink != null) "buyLink": buyLink,
        "readed": readed ?? false,
        if (tags != null) "tags": tags!.toList(),
        "createdAt": createdAt.toIso8601String(),
        "lastModification": lastModification.toIso8601String(),
      };
}
