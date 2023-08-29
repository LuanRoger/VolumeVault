import "package:flutter/material.dart";

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final double? iconSize;
  final TextStyle? textStyle;

  const IconText({
    required this.icon,
    required this.text,
    super.key,
    this.iconSize,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: iconSize),
        const SizedBox(width: 5),
        Text(
          text,
          style: textStyle ?? Theme.of(context).textTheme.bodyLarge,
        )
      ],
    );
  }
}
