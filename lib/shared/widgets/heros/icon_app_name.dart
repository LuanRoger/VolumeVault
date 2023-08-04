import "package:flutter/material.dart";
import "package:volume_vault/shared/assets/app_images.dart";
import "package:volume_vault/shared/theme/text_themes.dart";

class IconAppName extends StatelessWidget {
  final Axis axis;
  final TextStyle? style;
  final double? imageWidth;
  final double? imageHeight;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const IconAppName({
    this.axis = Axis.vertical,
    this.style,
    this.imageHeight,
    this.imageWidth,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const appName = "Volume Vault";
    final composition = [
      Image(
        image: AppImages.volumeVaultIcon,
        width: imageWidth ?? 100,
        height: imageHeight ?? 100,
        fit: BoxFit.contain,
      ),
      Text(
        appName,
        style: style ?? headlineLarge,
      )
    ];

    return axis == Axis.vertical
        ? Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: composition,
          )
        : Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: composition,
          );
  }
}
