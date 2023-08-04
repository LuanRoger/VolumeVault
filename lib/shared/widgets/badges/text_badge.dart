import "package:flutter/material.dart";

class TextBadge extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? fillColor;
  final double? width;
  final double? height;

  const TextBadge(
      {required this.text, this.color, this.fillColor, this.width, this.height, super.key});

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? Theme.of(context).colorScheme.primary;

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: badgeColor),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: TextStyle(
            color: badgeColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
