import 'package:flutter/material.dart';

class BookImageViewer extends StatelessWidget {
  ImageProvider image;
  int sizeMultiplier;
  double borderWidth;

  final double _height = 250.0;
  final double _width = 175.0;

  BookImageViewer(
      {super.key,
      required this.image,
      this.sizeMultiplier = 1,
      this.borderWidth = 0.5});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(width: borderWidth),
      ),
      height: _height * sizeMultiplier,
      width: _width * sizeMultiplier,
      child: Image(
        image: image,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.image_not_supported_rounded),
      ),
    );
  }
}
