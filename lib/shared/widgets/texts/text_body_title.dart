import "package:flutter/material.dart";

class TextBodyTitle extends StatelessWidget {
  final String text;

  const TextBodyTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.surfaceTint,
          fontWeight: FontWeight.bold),
    );
  }
}
