import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/controllers/auth_controller.dart';
import 'package:volume_vault/models/enums/auth_result_status.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/signin_result.dart';
import 'package:volume_vault/services/models/user_signin_request.dart';

abstract class SigninUserPageStragegy {
  Future<AuthResultStatus> signinUser(
      WidgetRef ref, UserSigninRequest request) async {
    AuthController controller = await ref.read(authControllerProvider.future);
    SigninResult signinResult = await controller.signinUser(request);

    if (signinResult.resultStatus == AuthResultStatus.created) {
      ref
          .read(userSessionNotifierProvider.notifier)
          .changeUserSessionToken(signinResult.jwtToken);
    }

    return signinResult.resultStatus;
  }
}
