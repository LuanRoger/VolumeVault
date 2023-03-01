import 'package:volume_vault/models/http_code.dart';

class LoginResult {
  String? jwtToken;
  HttpCode requestCode;

  LoginResult({required this.jwtToken, required this.requestCode});
}
