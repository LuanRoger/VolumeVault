import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/enums/signin_auth_result.dart';
import 'package:volume_vault/pages/login_signin_page/commands/signin_user_page_mobile_commands.dart';
import 'package:volume_vault/services/models/user_signin_request.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/ui_utils/snackbar_utils.dart';
import 'package:volume_vault/shared/validators/text_field_validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SigninSection extends HookConsumerWidget {
  final SigninUserPageMobileCommands _commands = SigninUserPageMobileCommands();
  static final GlobalKey<FormState> _signinFormKey = GlobalKey<FormState>();

  final Widget? loadingProgressIndicator;
  final void Function()? onLoginButtonPressed;

  SigninSection(
      {super.key, this.onLoginButtonPressed, this.loadingProgressIndicator});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoadingState = useState(false);
    final obscurePassword = useState(true);

    return isLoadingState.value
        ? loadingProgressIndicator ??
            const Center(child: CircularProgressIndicator())
        : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: _signinFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: usernameController,
                      validator: minumumLenght3,
                      decoration: InputDecoration(
                        label: Text(
                            AppLocalizations.of(context)!.userTextFieldHint),
                        filled: true,
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 15),
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
                        if (!_signinFormKey.currentState!.validate()) {
                          return;
                        }
                        isLoadingState.value = true;

                        final signinResult = await _commands.signinUser(
                          ref,
                          UserSigninRequest(
                              username: usernameController.text,
                              email: emailController.text,
                              password: passwordController.text),
                        );

                        // ignore: use_build_context_synchronously
                        if (!context.mounted) return;

                        if (signinResult != SigninAuthResult.success) {
                          SnackbarUtils.showUserSignupAuthErrorSnackbar(context,
                              authResultStatus: signinResult);
                          isLoadingState.value = false;
                          return;
                        }

                        context.goNamed(AppRoutes.homeRouteName);
                      },
                      child: Text(
                          AppLocalizations.of(context)!.signinButtonSigninPage),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .alreadyHaveAccountSigninPage,
                        ),
                        TextButton(
                          onPressed: onLoginButtonPressed,
                          child: Text(AppLocalizations.of(context)!
                              .loginButtonSigninPage),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
  }
}
