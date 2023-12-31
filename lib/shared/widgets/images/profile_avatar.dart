import "package:flutter/material.dart";
import "package:volume_vault/shared/theme/text_themes.dart";
import "package:volume_vault/shared/widgets/fx/shimmer_effect.dart";

class ProfileAvatar extends StatelessWidget {
  final ImageProvider? image;
  final String letter;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double? height;
  final double? width;
  final bool isLoading;
  final Color? letterBackgroundColor;

  const ProfileAvatar(this.letter,
      {super.key,
      this.image,
      this.textStyle,
      this.padding,
      this.height,
      this.width,
      this.letterBackgroundColor,
      this.isLoading = false})
      : assert(letter.length == 1, "Letter must be a single character");

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Container(
            clipBehavior: Clip.antiAlias,
            padding: padding,
            height: height,
            width: width,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: letterBackgroundColor ??
                    Theme.of(context).colorScheme.surfaceVariant),
            child: image != null
                ? Image(
                    key: UniqueKey(),
                    image: image!,
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: Text(
                      letter,
                      style: textStyle ?? headlineLarge,
                    ),
                  ),
          )
        : ShimmerEffect(
            width: width,
            height: height,
            padding: padding,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surfaceVariant),
          );
  }
}
