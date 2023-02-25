import 'package:volume_vault/models/http_code.dart';

class HttpResponse {
  final HttpCode statusCode;
  final String body;

  HttpResponse({required this.statusCode, required this.body});
}
