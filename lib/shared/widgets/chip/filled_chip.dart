import "package:flutter/material.dart";

class FilledChip extends StatelessWidget {
  final String label;

  const FilledChip({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return RawChip(
      label: Text(label),
      tapEnabled: false,
      side: BorderSide.none,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}
