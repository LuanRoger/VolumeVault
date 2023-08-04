import "package:flutter/material.dart";
import "package:shimmer/shimmer.dart";

class ShimmerEffect extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;

  const ShimmerEffect({
    this.height,
    this.width,
    this.padding,
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).colorScheme.background;
    final highlightColor = Theme.of(context).colorScheme.surfaceVariant;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: decoration ??
            BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
        child: const SizedBox.expand(),
      ),
    );
  }
}
