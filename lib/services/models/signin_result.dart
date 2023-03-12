import 'package:volume_vault/models/http_code.dart';

class SigninResult {
  final String jwtToken;
  final HttpCode requestCode;

  SigninResult({required this.jwtToken, required this.requestCode});
}
