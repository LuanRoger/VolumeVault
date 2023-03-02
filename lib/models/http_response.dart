import 'package:volume_vault/models/http_code.dart';

class HttpResponse {
  final HttpCode statusCode;
  final dynamic body;

  HttpResponse({required this.statusCode, required this.body});

  factory HttpResponse.error({String? message, int? code}) => HttpResponse(
      statusCode: HttpCode.fromInt(code ?? -1), body: message ?? "");
}
