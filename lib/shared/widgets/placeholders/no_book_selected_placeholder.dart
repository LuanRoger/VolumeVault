import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:volume_vault/shared/theme/text_themes.dart";

class NoBookSelectedPlaceholder extends StatelessWidget {
  const NoBookSelectedPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.info_outline_rounded, size: 100),
        Text(AppLocalizations.of(context)!.noBookSelectedPlaceholderText,
            style: headlineSmall),
      ],
    );
  }
}
