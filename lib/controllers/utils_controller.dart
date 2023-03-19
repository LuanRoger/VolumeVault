import 'package:volume_vault/models/enums/authorization_status.dart';
import 'package:volume_vault/models/http_code.dart';
import 'package:volume_vault/services/utils_service.dart';

class UtilsController {
  final UtilsService _service;

  const UtilsController(this._service);

  Future<bool> ping() async {
    final response = await _service.ping();

    return response.statusCode == HttpCode.OK;
  }

  Future<AuthorizationStatus> checkAuthorizationStatus(String token) async {
    final response = await _service.checkAuthToken(token);

    switch (response.statusCode) {
      case HttpCode.OK:
        return AuthorizationStatus.authorized;
      default:
        return AuthorizationStatus.denied;
    }
  }
}
