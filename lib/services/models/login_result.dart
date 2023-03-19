import 'package:volume_vault/models/enums/login_result_status.dart';


class LoginResult {
  String? jwtToken;
  AuthResultStatus resultStatus;

  LoginResult({required this.jwtToken, required this.resultStatus});
}
