import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:volume_vault/models/enums/login_auth_result.dart";
import "package:volume_vault/providers/providers.dart";
import "package:volume_vault/services/models/user_login_request.dart";
import "package:volume_vault/shared/widgets/dialogs/input_dialog.dart";

abstract class LoginUserStrategy {
  Future<LoginAuthResult> login(WidgetRef ref, UserLoginRequest request) async {
    final controller = ref.read(userSessionAuthProvider.notifier);
    return controller.loginUser(request);
  }

  Future<(bool, String?)> sendResetPasswordEmail(
      TextEditingController emailController,
      {required BuildContext context,
      required WidgetRef ref}) async {
    final inputDialog = InputDialog(
      controller: emailController,
      icon: const Icon(Icons.email),
      textFieldLabel: Text(AppLocalizations.of(context)!.emailTextFieldHint),
      title: AppLocalizations.of(context)!.resetPasswordDialogTitle,
    );

    await inputDialog.show(context);
    if (emailController.text.isEmpty) return (false, null);

    final userSessionController = ref.read(userSessionAuthProvider.notifier);
    await userSessionController.recoveryFogotenPassword(emailController.text);
    return (true, emailController.text);
  }
}
