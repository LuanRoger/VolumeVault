import "package:flutter/material.dart";
import "package:volume_vault/shared/widgets/badges/text_badge.dart";

class BasicBadge extends StatelessWidget {
  final double? width;
  final double? height;

  const BasicBadge({this.height, this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return TextBadge(
      text: "Basic",
      color: Colors.grey.shade400,
      height: height,
      width: width,
    );
  }
}
