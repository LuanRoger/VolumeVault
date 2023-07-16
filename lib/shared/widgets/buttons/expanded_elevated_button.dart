import "package:flutter/material.dart";

class ExpandedElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? child;

  const ExpandedElevatedButton(
      {required this.onPressed, super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: SizedBox(width: double.infinity, child: child),
    );
  }
}
