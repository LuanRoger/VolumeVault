import 'package:flutter/material.dart';

class LetterAvatar extends StatelessWidget {
  final String letter;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;

  const LetterAvatar(this.letter,
      {super.key, this.padding, this.height, this.width})
      : assert(letter.length == 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      height: height,
      width: width,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surfaceVariant),
      child: Center(
        child: Text(letter, style: Theme.of(context).textTheme.headlineLarge),
      ),
    );
  }
}
