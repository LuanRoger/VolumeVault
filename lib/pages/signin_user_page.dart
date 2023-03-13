import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:volume_vault/models/http_code.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/signin_result.dart';
import 'package:volume_vault/services/models/user_signin_request.dart';
import 'package:volume_vault/shared/assets/app_images.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/validators/text_field_validator.dart';

class SigninUserPage extends HookConsumerWidget {
  final GlobalKey<FormState> _signinFormKey = GlobalKey<FormState>();

  SigninUserPage({super.key});

  Future<SigninResult> _signin(WidgetRef ref,
      {required UserSigninRequest signinRequest}) async {
    final loginProvider = await ref.read(authServiceProvider.future);
    SigninResult result = await loginProvider.signin(signinRequest);

    return result;
  }

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
                              "Mantenha seus livros salvos",
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
                                    decoration: const InputDecoration(
                                      label: Text("Usuário"),
                                      filled: true,
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    controller: emailController,
                                    validator: matchEmailRegex,
                                    decoration: const InputDecoration(
                                      label: Text("Email"),
                                      filled: true,
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    controller: passwordController,
                                    validator: minumumLenght8AndMaximum18,
                                    obscureText: obscurePassword.value,
                                    decoration: InputDecoration(
                                      label: const Text("Senha"),
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

                                      SigninResult result = await _signin(ref,
                                          signinRequest: UserSigninRequest(
                                              username: usernameController.text,
                                              email: emailController.text,
                                              password:
                                                  passwordController.text));

                                      if (result.requestCode !=
                                          HttpCode.CREATED) {
                                        switch (result.requestCode) {
                                          case HttpCode.NOT_FOUND:
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content:
                                                  Text("O usuário não existe."),
                                            ));
                                            break;
                                          case HttpCode.CONFLICT:
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content:
                                                  Text("O usuário já existe."),
                                            ));
                                            break;
                                          default:
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Occoreu um error. (${result.requestCode.code})"),
                                              ),
                                            );
                                            break;
                                        }
                                        isLoadingState.value = false;
                                        return;
                                      }

                                      ref
                                          .read(userSessionNotifierProvider
                                              .notifier)
                                          .changeUserSessionToken(
                                              result.jwtToken);
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          AppRoutes.homePageRoute,
                                          (_) => false);
                                    },
                                    child: const Text("Registrar-se"),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text("Já possui uma conta?"),
                                      TextButton(
                                        onPressed: () => Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                AppRoutes.loginPageRoute,
                                                (_) => false),
                                        child: const Text("Entre aqui"),
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
