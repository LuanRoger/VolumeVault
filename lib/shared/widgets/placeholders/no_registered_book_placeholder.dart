import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:lottie/lottie.dart";
import "package:volume_vault/shared/assets/app_animations.dart";

class NoRegisteredBookPlaceholder extends StatelessWidget {
  const NoRegisteredBookPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(AppAnimations.noBooks, height: 200, width: 200),
        Text(
          AppLocalizations.of(context)!.noRegisteredBooksPlaceholderText,
          style: Theme.of(context).textTheme.headlineSmall,
        )
      ],
    );
  }
}
