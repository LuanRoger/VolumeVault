class GetUserBookRequest {
  final int page;
  final int limitPerPage;

  GetUserBookRequest({
    required this.page,
    this.limitPerPage = 10,
  });

  Map<String, String> forRequest() => {
        "page": page.toString(),
        "limitPerPage": limitPerPage.toString(),
      };
  GetUserBookRequest copyWith({int? page, int? limitPerPage}) {
    return GetUserBookRequest(
      page: page ?? this.page,
      limitPerPage: limitPerPage ?? this.limitPerPage,
    );
  }
}
