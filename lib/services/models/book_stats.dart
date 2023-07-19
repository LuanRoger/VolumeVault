class BookStats {
  final int count;

  BookStats({required this.count});

  factory BookStats.fromJson(Map<String, dynamic> json) {
    return BookStats(count: json["count"] as int);
  }
}
