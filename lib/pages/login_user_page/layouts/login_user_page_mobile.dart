import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/enums/auth_result_status.dart';
import 'package:volume_vault/pages/login_user_page/commands/login_user_mobile_commands.dart';
import 'package:volume_vault/services/models/user_login_request.dart';
import 'package:volume_vault/shared/assets/app_images.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/ui_utils/snackbar_utils.dart';
import 'package:volume_vault/shared/validators/text_field_validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginUserPageMobile extends HookConsumerWidget {
  final LoginUserMobileCommands _command = LoginUserMobileCommands();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  LoginUserPageMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoadingState = useState(false);
    final obscurePassword = useState(true);

    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoadingState.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: AppImages.loginImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.wellcomeBackLoginPage,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Form(
                          key: _loginFormKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: usernameController,
                                validator: minumumLenght3,
                                decoration: InputDecoration(
                                  label: Text(AppLocalizations.of(context)!
                                      .userTextFieldHint),
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
                                    onPressed: () => obscurePassword.value =
                                        !obscurePassword.value,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              ElevatedButton(
                                  onPressed: () async {
                                    if (!_loginFormKey.currentState!
                                        .validate()) {
                                      return;
                                    }
                                    isLoadingState.value = true;

                                    final loginResult = await _command.login(
                                        ref,
                                        UserLoginRequest(
                                            username: usernameController.text,
                                            password: passwordController.text));

                                    // ignore: use_build_context_synchronously
                                    if (!context.mounted) return;
                                    if (loginResult !=
                                        AuthResultStatus.created) {
                                      SnackbarUtils.showUserAuthErrorSnackbar(
                                          context,
                                          authResultStatus: loginResult);
                                    }

                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      AppRoutes.homePageRoute,
                                      (_) => false,
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
                              onPressed: () => Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                      AppRoutes.signinPageRoute, (_) => false),
                              child: Text(AppLocalizations.of(context)!
                                  .signinButtonLoginPage),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    ));
  }
}
