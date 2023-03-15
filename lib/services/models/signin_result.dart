import 'package:volume_vault/models/enums/login_result_status.dart';

class SigninResult {
  final String jwtToken;
  final AuthResultStatus resultStatus;

  SigninResult({required this.jwtToken, required this.resultStatus});
}
