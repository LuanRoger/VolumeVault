import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:volume_vault/models/enums/badge_code.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BadgetViewer extends StatelessWidget {
  final BadgeCode badgeCode;

  const BadgetViewer({super.key, required this.badgeCode});

  @override
  Widget build(BuildContext context) {
    final creatorIconColor = Theme.of(context).colorScheme.primary;
    final sponsorIconColor = Colors.pink[300];
    final contributorIconColor = Colors.purple[300];
    final testerIconColor = Colors.red[300];
    final bugHunterIconColor = Colors.green[300];
    final earlyAccessIconColor = Colors.blue[300];

    return switch (badgeCode) {
      BadgeCode.creator => Tooltip(
          message: AppLocalizations.of(context)!.badgeCreator,
          child: Icon(
            LucideIcons.keyRound,
            color: creatorIconColor,
          ),
        ),
        BadgeCode.sponsor => Tooltip(
          message: AppLocalizations.of(context)!.badgeSponsor,
          child: Icon(
            LucideIcons.heart,
            color: sponsorIconColor,
          ),
        ),
      BadgeCode.openSourceContributor => Tooltip(
          message: AppLocalizations.of(context)!.badgeContributor,
          child: Icon(
            LucideIcons.gitMerge,
            color: contributorIconColor,
          ),
        ),
      BadgeCode.tester => Tooltip(
          message: AppLocalizations.of(context)!.badgeTester,
          child: Icon(
            LucideIcons.flaskConical,
            color: testerIconColor,
          ),
        ),
      BadgeCode.bugHunter => Tooltip(
          message: AppLocalizations.of(context)!.badgeBugHunter,
          child: Icon(
            LucideIcons.bug,
            color: bugHunterIconColor,
          ),
        ),
      BadgeCode.earlyAccessUser => Tooltip(
          message: AppLocalizations.of(context)!.badgeEarlyAccessUser,
          child: Icon(
            LucideIcons.rocket,
            color: earlyAccessIconColor,
          ),
        ),
    };
  }
}
