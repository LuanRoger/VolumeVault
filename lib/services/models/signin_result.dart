import 'package:volume_vault/models/enums/auth_result_status.dart';

class SigninResult {
  final String jwtToken;
  final AuthResultStatus resultStatus;

  SigninResult({required this.jwtToken, required this.resultStatus});
}
