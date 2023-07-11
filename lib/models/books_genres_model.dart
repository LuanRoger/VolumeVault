class BooksGenresModel {
  final int count;
  final Set<String> genres;

  BooksGenresModel({required this.count, required this.genres});

  factory BooksGenresModel.fromJson(Map<String, dynamic> json) =>
      BooksGenresModel(
        count: json["count"] as int,
        genres:
            (json["genres"] as List<dynamic>).map((e) => e as String).toSet(),
      );
}
