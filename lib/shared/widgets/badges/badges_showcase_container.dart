import 'package:flutter/material.dart';
import 'package:volume_vault/models/enums/badge_code.dart';
import 'package:volume_vault/shared/widgets/badges/badge_viewer.dart';

class BadgesShowcaseContainer extends StatelessWidget {
  final List<BadgeCode> badgesCodes;

  const BadgesShowcaseContainer({super.key, required this.badgesCodes});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final badge in badgesCodes) BadgetViewer(badgeCode: badge)
          ],
        ));
  }
}
