import 'package:volume_vault/models/http_code.dart';

class SiginResult {
  final String jwtToken;
  final HttpCode requestCode;

  SiginResult({required this.jwtToken, required this.requestCode});
}
