import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoRegisteredBookPlaceholder extends StatelessWidget {
  const NoRegisteredBookPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.book, size: 100),
        Text(
          AppLocalizations.of(context)!.noRegisteredBooksPlaceholderText,
          style: Theme.of(context).textTheme.headlineSmall,
        )
      ],
    );
  }
}
