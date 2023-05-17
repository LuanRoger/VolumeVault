import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/enums/login_auth_result.dart';
import 'package:volume_vault/providers/interfaces/user_session_state.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/user_login_request.dart';

abstract class LoginUserStrategy {
  Future<LoginAuthResult> login(WidgetRef ref, UserLoginRequest request) async {
    UserSessionState controller = ref.read(userSessionAuthProvider.notifier);
    return await controller.loginUser(request);
  }
}
