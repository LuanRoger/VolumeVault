import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:volume_vault/models/enums/login_auth_result.dart";
import "package:volume_vault/models/enums/signin_auth_result.dart";

abstract class SnackbarUtils {
  static void showUserLoginAuthErrorSnackbar(BuildContext context,
      {required LoginAuthResult authResultStatus}) {
    switch (authResultStatus) {
      case LoginAuthResult.invalidEmail:
      case LoginAuthResult.wrongPassword:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!
                .incorrectCredentialErrorSnackbarMessage),
          ),
        );
      case LoginAuthResult.userNotFound:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!
                .emailAlreadyInUseErrorSnackbarMessage),
          ),
        );
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)!.aErrorOccursErrorSnackbarMessage),
          ),
        );
    }
  }

  static void showResetPasswordEmailSendSnackbar(BuildContext context,
      {String? email}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!
              .recoveryPasswordEmailSentSnackbarMessage(email),
        ),
      ),
    );
  }

  static void showUserSignupAuthErrorSnackbar(BuildContext context,
      {required SigninAuthResult authResultStatus}) {
    switch (authResultStatus) {
      case SigninAuthResult.emailAlreadyInUse:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!
                .emailAlreadyInUseErrorSnackbarMessage),
          ),
        );
      case SigninAuthResult.invalidEmail:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)!.invalidEmailErrorSnackbarMessage),
          ),
        );
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)!.aErrorOccursErrorSnackbarMessage),
          ),
        );
    }
  }

  static void showUserEmailVerificationSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.verificationEmailSentSnackbarMessage,
        ),
      ),
    );
  }

  static void showErrorBadgeClaimSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.errorBadgeClaimSnackbarMessage,
        ),
      ),
    );
  }
}
