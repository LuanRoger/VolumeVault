import "package:flutter/material.dart";

class BookImageViewer extends StatelessWidget {
  final ImageProvider? image;
  final Widget? placeholder;
  final double sizeMultiplier;
  final double borderWidth;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final BoxFit? fit;

  static const double _height = 250;
  static const double _width = 175;

  const BookImageViewer(
      {required this.image,
      super.key,
      this.placeholder,
      this.sizeMultiplier = 1,
      this.borderWidth = 0.5,
      this.border,
      this.borderRadius,
      this.fit});

  @override
  Widget build(BuildContext context) {
    final useMultiplier = fit == null;
    final containerHeight = _height * sizeMultiplier;
    final containerWidth = _width * sizeMultiplier;

    return Container(
      clipBehavior: Clip.hardEdge,
      height: useMultiplier ? containerHeight : null,
      width: useMultiplier ? containerWidth : null,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(15),
        border: border ?? Border.all(width: borderWidth),
      ),
      child: image != null
          ? Image(
              image: image!,
              height: useMultiplier ? _height * sizeMultiplier : null,
              width: useMultiplier ? _width * sizeMultiplier : null,
              fit: useMultiplier ? BoxFit.cover : fit,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported_rounded),
            )
          : placeholder,
    );
  }
}
