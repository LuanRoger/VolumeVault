import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/http_code.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/sigin_result.dart';
import 'package:volume_vault/services/models/user_sigin_request.dart';
import 'package:volume_vault/shared/assets/app_images.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/validators/text_field_validator.dart';

class SiginUserPage extends HookConsumerWidget {
  final GlobalKey<FormState> _siginFormKey = GlobalKey<FormState>();

  SiginUserPage({super.key});

  Future<SiginResult> _signin(WidgetRef ref,
      {required UserSiginRequest signinRequest}) async {
    final loginProvider = await ref.read(authServiceProvider.future);
    SiginResult result = await loginProvider.sigin(signinRequest);

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
              : Column(children: [
                  Expanded(
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
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Text(
                          "Mantenha seus livros salvos",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Form(
                          key: _siginFormKey,
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
                                  if (!_siginFormKey.currentState!.validate()) {
                                    return;
                                  }
                                  isLoadingState.value = true;

                                  SiginResult result = await _signin(ref,
                                      signinRequest: UserSiginRequest(
                                          username: usernameController.text,
                                          email: emailController.text,
                                          password: passwordController.text));

                                  if (result.requestCode != HttpCode.CREATED) {
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
                                          content: Text("O usuário já existe."),
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
                                      .read(
                                          userSessionNotifierProvider.notifier)
                                      .changeUserSessionToken(result.jwtToken);
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      AppRoutes.homePageRoute, (_) => false);
                                },
                                child: const Text("Registrar-se"),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
