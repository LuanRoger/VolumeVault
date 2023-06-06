import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';

class ProfileSectionStrategy {
  Future<void> showLogoutDialog(BuildContext context, WidgetRef ref) async {
    bool exit = false;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.signoutDialogTitle),
          content: Text(AppLocalizations.of(context)!.signoutDialogMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancelDialogButton),
            ),
            TextButton(
              onPressed: () {
                exit = true;
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.exitDialogButton),
            ),
          ]),
    );

    if (exit) {
      await ref.read(userSessionAuthProvider.notifier).logout();
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.loginSigninPage, (_) => false);
    }
  }
}
