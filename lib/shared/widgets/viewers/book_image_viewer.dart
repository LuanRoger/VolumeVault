import 'package:flutter/material.dart';

class BookImageViewer extends StatelessWidget {
  ImageProvider image;
  double sizeMultiplier;
  double borderWidth;
  BoxBorder? border;
  BorderRadius? borderRadius;

  final double _height = 250.0;
  final double _width = 175.0;

  BookImageViewer(
      {super.key,
      required this.image,
      this.sizeMultiplier = 1,
      this.borderWidth = 0.5,
      this.border,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      height: _height * sizeMultiplier,
      width: _width * sizeMultiplier,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(15.0),
        border: border ?? Border.all(width: borderWidth),
      ),
      child: Image(
        image: image,
        height: _height * sizeMultiplier,
        width: _width * sizeMultiplier,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.image_not_supported_rounded),
      ),
    );
  }
}
