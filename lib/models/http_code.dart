enum HttpCode {
  ok(200),
  created(201),
  badRequest(400),
  unauthorized(401),
  notFound(404),
  conflict(409),
  badGateway(502),
  unknown(-1);

  final int code;

  const HttpCode(this.code);
  factory HttpCode.fromInt(int code) {
    switch (code) {
      case 200:
        return ok;
      case 201:
        return created;
      case 400:
        return badRequest;
      case 401:
        return unauthorized;
      case 404:
        return notFound;
      case 409:
        return conflict;
      case 502:
        return badGateway;
      default:
        return unknown;
    }
  }
}
