import 'package:flutter/material.dart';
import 'package:volume_vault/models/enums/login_auth_result.dart';
import 'package:volume_vault/models/enums/signin_auth_result.dart';

abstract class SnackbarUtils {
  static void showUserLoginAuthErrorSnackbar(BuildContext context,
      {required LoginAuthResult authResultStatus}) {
    switch (authResultStatus) {
      case LoginAuthResult.invalidEmail:
      case LoginAuthResult.wrongPassword:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Suas credenciais estão incorretas."),
          ),
        );
        break;
      case LoginAuthResult.userNotFound:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Este usuário não existe. Crie uma conta."),
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Occoreu um error."),
          ),
        );
        break;
    }
  }

  static void showUserSignupAuthErrorSnackbar(BuildContext context,
      {required SigninAuthResult authResultStatus}) {
    switch (authResultStatus) {
      case SigninAuthResult.emailAlreadyInUse:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("O email já está em uso"),
          ),
        );
        break;
      case SigninAuthResult.invalidEmail:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("O email não é valido"),
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Occoreu um error."),
          ),
        );
        break;
    }
  }
}
