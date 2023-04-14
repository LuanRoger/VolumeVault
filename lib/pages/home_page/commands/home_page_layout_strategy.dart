import 'package:flutter/material.dart';
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
}
