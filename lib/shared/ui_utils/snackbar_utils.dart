import 'package:flutter/material.dart';
import 'package:volume_vault/models/enums/auth_result_status.dart';

abstract class SnackbarUtils {
  static void showUserAuthErrorSnackbar(BuildContext context,
      {required AuthResultStatus authResultStatus}) {
    switch (authResultStatus) {
      case AuthResultStatus.wrongInformations:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Suas credenciais estão incorretas."),
          ),
        );
        break;
      case AuthResultStatus.userNotFound:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Este usuário não existe. Crie uma conta."),
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Occoreu um error. (${authResultStatus.code})"),
          ),
        );
        break;
    }
  }
}
