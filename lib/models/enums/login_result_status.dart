import 'package:volume_vault/models/http_code.dart';

enum AuthResultStatus {
  success(200),
  wrongInformations(401),
  userNotFound(404),
  undefined(-1);

  final int code;

  const AuthResultStatus(this.code);

  factory AuthResultStatus.fromHttpCode(HttpCode code) =>
      AuthResultStatus.values.firstWhere(
        (e) => code.code == e.code,
        orElse: () => AuthResultStatus.undefined,
      );
}
