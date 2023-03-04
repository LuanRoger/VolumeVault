class EditBookRequest {
  String? title;
  String? author;
  String? isbn;
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
  DateTime lastModification;

  EditBookRequest({
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
    this.readed,
    this.tags,
    required this.lastModification,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "isbn": isbn,
        "publicationYear": publicationYear,
        "publisher": publisher,
        "edition": edition,
        "pagesNumber": pagesNumber,
        "genre": genre,
        "format": format,
        "observation": observation,
        "synopsis": synopsis,
        "coverLink": coverLink,
        "buyLink": buyLink,
        "tags": tags?.toList(),
        "readed": readed,
        "lastModification": lastModification.toIso8601String(),
      };
}