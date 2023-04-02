import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:volume_vault/controllers/auth_controller.dart';
import 'package:volume_vault/models/enums/auth_result_status.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/signin_result.dart';
import 'package:volume_vault/services/models/user_signin_request.dart';
import 'package:volume_vault/shared/assets/app_images.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/ui_utils/snackbar_utils.dart';
import 'package:volume_vault/shared/validators/text_field_validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SigninUserPage extends HookConsumerWidget {
  final GlobalKey<FormState> _signinFormKey = GlobalKey<FormState>();

  SigninUserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoadingState = useState(false);
    final obscurePassword = useState(true);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoadingState.value
              ? const Center(child: CircularProgressIndicator())
              : ResponsiveRowColumn(
                  columnCrossAxisAlignment: CrossAxisAlignment.center,
                  layout: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
                      ? ResponsiveRowColumnType.COLUMN
                      : ResponsiveRowColumnType.ROW,
                  children: [
                      ResponsiveRowColumnItem(
                        rowFlex: 2,
                        columnFlex: 1,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                              image: AppImages.signinImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      if (ResponsiveWrapper.of(context).isDesktop)
                        const ResponsiveRowColumnItem(
                            child: SizedBox(width: 20)),
                      ResponsiveRowColumnItem(
                        rowFlex: 1,
                        columnFlex: 3,
                        child: Column(
                          mainAxisAlignment:
                              ResponsiveWrapper.of(context).isDesktop
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .keepYourBooksSafeSigninPage,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Form(
                              key: _signinFormKey,
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
                                    controller: emailController,
                                    validator: matchEmailRegex,
                                    decoration: InputDecoration(
                                      label: Text(AppLocalizations.of(context)!
                                          .emailTextFieldHint),
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
                                      if (!_signinFormKey.currentState!
                                          .validate()) {
                                        return;
                                      }
                                      isLoadingState.value = true;

                                      AuthController controller = await ref
                                          .read(authControllerProvider.future);
                                      SigninResult signinResult =
                                          await controller.signinUser(
                                        UserSigninRequest(
                                            username: usernameController.text,
                                            email: emailController.text,
                                            password: passwordController.text),
                                      );

                                      if (signinResult.resultStatus !=
                                          AuthResultStatus.created) {
                                        SnackbarUtils.showUserAuthErrorSnackbar(
                                            context,
                                            authResultStatus:
                                                signinResult.resultStatus);
                                        isLoadingState.value = false;
                                        return;
                                      }

                                      ref
                                          .read(userSessionNotifierProvider
                                              .notifier)
                                          .changeUserSessionToken(
                                              signinResult.jwtToken);
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        AppRoutes.homePageRoute,
                                        (_) => false,
                                      );
                                    },
                                    child: Text(AppLocalizations.of(context)!
                                        .signinButtonSigninPage),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .alreadyHaveAccountSigninPage,
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                AppRoutes.loginPageRoute,
                                                (_) => false),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .loginButtonSigninPage),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
        ),
      ),
    );
  }
}
