import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/enums/login_auth_result.dart';
import 'package:volume_vault/pages/login_signin_page/commands/login_user_mobile_commands.dart';
import 'package:volume_vault/services/models/user_login_request.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/ui_utils/snackbar_utils.dart';
import 'package:volume_vault/shared/validators/text_field_validator.dart';

class LoginSection extends HookConsumerWidget {
  final LoginUserMobileCommands _command = LoginUserMobileCommands();
  static final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  final Widget? loadingProgressIndicator;
  final void Function()? onSigninButtonPressed;

  LoginSection(
      {super.key, this.onSigninButtonPressed, this.loadingProgressIndicator});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoadingState = useState(false);
    final obscurePassword = useState(true);

    return isLoadingState.value
        ? loadingProgressIndicator ??
            const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Form(
                key: _loginFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      validator: matchEmailRegex,
                      decoration: InputDecoration(
                        label: Text(
                            AppLocalizations.of(context)!.emailTextFieldHint),
                        filled: true,
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: passwordController,
                      validator: minumumLenght8AndMaximum18,
                      obscureText: obscurePassword.value,
                      decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context)!
                            .passwordTextFieldHint),
                        filled: true,
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide.none),
                        suffixIcon: IconButton(
                          icon: Icon(obscurePassword.value
                              ? Icons.remove_red_eye_rounded
                              : Icons.remove_red_eye_outlined),
                          onPressed: () =>
                              obscurePassword.value = !obscurePassword.value,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                        onPressed: () async {
                          if (!_loginFormKey.currentState!.validate()) {
                            return;
                          }
                          isLoadingState.value = true;

                          final loginResult = await _command.login(
                              ref,
                              UserLoginRequest(
                                  email: emailController.text,
                                  password: passwordController.text));

                          // ignore: use_build_context_synchronously
                          if (!context.mounted) return;
                          if (loginResult != LoginAuthResult.success) {
                            SnackbarUtils.showUserLoginAuthErrorSnackbar(
                                context,
                                authResultStatus: loginResult);
                            isLoadingState.value = false;
                            return;
                          }
                          //TODO: Check latter
                          context.go(
                            AppRoutes.homePageRoute,
                          );
                        },
                        child: Text(AppLocalizations.of(context)!
                            .loginButtonLoginPage)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!
                      .doesNotHaveAccountLoginPage),
                  TextButton(
                    onPressed: onSigninButtonPressed,
                    child: Text(
                        AppLocalizations.of(context)!.signinButtonLoginPage),
                  ),
                ],
              ),
            ],
          );
  }
}
