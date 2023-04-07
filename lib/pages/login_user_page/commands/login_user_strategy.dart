import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/controllers/auth_controller.dart';
import 'package:volume_vault/models/enums/auth_result_status.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/login_result.dart';
import 'package:volume_vault/services/models/user_login_request.dart';

abstract class LoginUserStrategy {
  Future<AuthResultStatus> login(
      WidgetRef ref, UserLoginRequest request) async {
    AuthController controller = await ref.read(authControllerProvider.future);
    LoginResult loginResult = await controller.loginUser(
      request,
    );
    if (loginResult.resultStatus != AuthResultStatus.success) {
      ref
          .read(userSessionNotifierProvider.notifier)
          .changeUserSessionToken(loginResult.jwtToken!);
    }
    return loginResult.resultStatus;
  }
}
