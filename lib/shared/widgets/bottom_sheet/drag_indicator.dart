import "package:flutter/material.dart";

class DragIndicator extends StatelessWidget {
  const DragIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: 32,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color:
              Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4)),
    );
  }
}
