import 'package:volume_vault/models/enums/auth_result_status.dart';

class LoginResult {
  String? jwtToken;
  AuthResultStatus resultStatus;

  LoginResult({required this.jwtToken, required this.resultStatus});
}
