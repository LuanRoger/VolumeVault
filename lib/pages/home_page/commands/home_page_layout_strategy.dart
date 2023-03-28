import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/enums/authorization_status.dart';
import 'package:volume_vault/providers/providers.dart';

abstract class HomePageLayoutStrategy {
  const HomePageLayoutStrategy();

  Future showErrorDialog(BuildContext context,
      {required bool connectionError,
      required bool authValidationError}) async {
    final String message = authValidationError
        ? "Não foi possível validar o token de autenticação. Faça login novamente."
        : "Não foi possível conectar ao servidor";

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Um problema ocorreu"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }

  Future<void> checkout(BuildContext context, WidgetRef ref) async {
    final bool connection = await checkConnection(ref);
    final bool token = await checkUserAuthToken(ref) ?? true;
    if (connection && token) return;

    await showErrorDialog(context,
        connectionError: connection, authValidationError: token);
  }

  Future<bool?> checkUserAuthToken(WidgetRef ref) async {
    final utilsController = await ref.read(utilsControllerProvider.future);
    final userSession = await ref.read(userSessionNotifierProvider.future);
    if (userSession.token.isEmpty) return null;

    final result =
        await utilsController.checkAuthorizationStatus(userSession.token);

    return result == AuthorizationStatus.authorized;
  }

  Future<bool> checkConnection(WidgetRef ref) async {
    final utilsController = await ref.read(utilsControllerProvider.future);

    return await utilsController.ping();
  }
}
