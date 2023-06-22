import "package:flutter/material.dart";

class PremiumBadge extends StatelessWidget {
  const PremiumBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.tertiary;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: accentColor, width: 1),
      ),
      child: Text(
        "Premium",
        style: TextStyle(
          color: accentColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
