import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/enums/signin_auth_result.dart';
import 'package:volume_vault/providers/interfaces/user_session_state.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/user_signin_request.dart';

abstract class SigninUserPageStragegy {
  Future<SigninAuthResult> signinUser(
      WidgetRef ref, UserSigninRequest request) async {
    UserSessionState controller = ref.read(userSessionAuthProvider.notifier);
    SigninAuthResult result = await controller.signinUser(request);

    return result;
  }
}
