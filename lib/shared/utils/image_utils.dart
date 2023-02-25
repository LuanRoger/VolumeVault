import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class ImageUtils {
  static Future<Color?> getDominantColor(ImageProvider image) async {
    try {
      final PaletteGenerator palette =
          await PaletteGenerator.fromImageProvider(image);
      return palette.dominantColor?.color;
    } catch (_) {
      return null;
    }
  }
}