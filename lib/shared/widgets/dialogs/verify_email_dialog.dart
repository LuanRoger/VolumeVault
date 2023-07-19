import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:volume_vault/providers/providers.dart";

class VerifyEmailDialog {
  Future<bool> show(BuildContext context, {required WidgetRef ref}) async {
    var sendEmail = false;
    await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.verifyEmailDialogTitle),
              content:
                  Text(AppLocalizations.of(context)!.verifyEmailDialogMessage),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    sendEmail = true;
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!
                      .sendVerificationEmailDialogButton),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(AppLocalizations.of(context)!.cancelDialogButton),
                )
              ],
            ));
    if (!sendEmail) return false;

    await ref.read(userSessionAuthProvider.notifier).sendVerificationEmail();
    return true;
  }
}
