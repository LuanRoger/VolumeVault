import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:volume_vault/models/enums/badge_code.dart';

class BadgetViewer extends StatelessWidget {
  final BadgeCode badgeCode;

  const BadgetViewer({super.key, required this.badgeCode});

  @override
  Widget build(BuildContext context) {
    final creatorIconColor = Theme.of(context).colorScheme.primary;
    final contributorIconColor = Colors.purple[300];
    final testerIconColor = Colors.red[300];
    final bugHunterIconColor = Colors.green[300];
    final earlyAccessIconColor = Colors.blue[300];

    return switch (badgeCode) {
      BadgeCode.creator => Tooltip(
          message: "Creator",
          child: Icon(
            LucideIcons.keyRound,
            color: creatorIconColor,
          ),
        ),
      BadgeCode.openSourceContributor => Tooltip(
          message: "Contributor",
          child: Icon(
            LucideIcons.gitMerge,
            color: contributorIconColor,
          ),
        ),
      BadgeCode.tester => Tooltip(
          message: "Tester",
          child: Icon(
            LucideIcons.flaskConical,
            color: testerIconColor,
          ),
        ),
      BadgeCode.bugHunter => Tooltip(
          message: "Bug Hunter",
          child: Icon(
            LucideIcons.bug,
            color: bugHunterIconColor,
          ),
        ),
      BadgeCode.earlyAccessUser => Tooltip(
          message: "Early Access User",
          child: Icon(
            LucideIcons.rocket,
            color: earlyAccessIconColor,
          ),
        ),
    };
  }
}
