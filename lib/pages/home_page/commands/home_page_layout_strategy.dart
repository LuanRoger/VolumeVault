import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/enums/authorization_status.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class HomePageLayoutStrategy {
  const HomePageLayoutStrategy();

  Future showErrorDialog(BuildContext context,
      {required bool connectionError,
      required bool authValidationError}) async {
    final String message = authValidationError
        ? AppLocalizations.of(context)!.authErrorDialogMessage
        : AppLocalizations.of(context)!.serverConnectionErrorDialogMessage;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.problemDialogTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.okDialogButton),
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
