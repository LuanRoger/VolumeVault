import "package:flutter/material.dart";
import "package:volume_vault/shared/widgets/badges/text_badge.dart";

class PremiumBadge extends StatelessWidget {
  final double? width;
  final double? height;

  const PremiumBadge({this.width, this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return TextBadge(
      text: "Premium",
      color: Theme.of(context).colorScheme.tertiary,
      height: height,
      width: width,
    );
  }
}
