import 'package:flutter/foundation.dart';

enum HttpCode {
  OK(200),
  CREATED(201),
  BAD_REQUEST(400),
  UNAUTHORIZED(401),
  NOT_FOUND(404),
  CONFLICT(409),
  BAD_GATEWAY(502),
  UNKNOWN(-1);

  final int code;

  const HttpCode(this.code);
  factory HttpCode.fromInt(int code) {
    switch (code) {
      case 200:
        return OK;
      case 201:
        return CREATED;
      case 400:
        return BAD_REQUEST;
      case 401:
        return UNAUTHORIZED;
      case 404:
        return NOT_FOUND;
      case 409:
        return CONFLICT;
      case 502:
        return BAD_GATEWAY;
      default:
        return UNKNOWN;
    }
  }
}
