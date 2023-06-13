import 'package:flutter/material.dart';

class TransparentCircularBorder extends StatelessWidget {
  final Widget child;
  final double padding;

  const TransparentCircularBorder(
      {super.key, required this.child, this.padding = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surface,
      ),
      child: child,
    );
  }
}
