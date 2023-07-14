import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:lucide_icons/lucide_icons.dart";
import "package:volume_vault/shared/ui_utils/snackbar_utils.dart";
import "package:volume_vault/shared/widgets/dialogs/verify_email_dialog.dart";

class VerifierdBadge extends ConsumerWidget {
  final bool isVerified;
  final bool canVerify;

  const VerifierdBadge({
    super.key,
    this.isVerified = false,
    this.canVerify = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return isVerified
        ? Tooltip(
            message: AppLocalizations.of(context)!.badgeVerifiedAccount,
            child: const Icon(LucideIcons.badgeCheck, color: Colors.blue))
        : GestureDetector(
            onTap: () async {
              final sendEmail =
                  await VerifyEmailDialog().show(context, ref: ref);

              // ignore: use_build_context_synchronously
              if (!sendEmail || !context.mounted) return;

              SnackbarUtils.showUserEmailVerificationSnackbar(context);
            },
            child: Tooltip(
                message: AppLocalizations.of(context)!.badgeUnverifiedAccount,
                child:
                    const Icon(LucideIcons.badgeAlert, color: Colors.yellow)),
          );
  }
}
