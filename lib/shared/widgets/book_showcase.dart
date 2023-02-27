import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:volume_vault/shared/widgets/book_image_viewer.dart';
import 'package:volume_vault/shared/widgets/radial_light.dart';

class BookShowcase extends StatelessWidget {
  final Color? color;
  final Size size;
  final ImageProvider image;
  bool lightEffect;
  Clip clipBehavior;
  Alignment alignment;

  BookShowcase(
      {super.key,
      this.color,
      required this.size,
      required this.image,
      this.lightEffect = true,
      this.clipBehavior = Clip.hardEdge,
      this.alignment = Alignment.center});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        clipBehavior: clipBehavior,
        alignment: alignment,
        children: [
          if (color != null && lightEffect)
            Animate(
              effects: const [
                ScaleEffect(
                    duration: Duration(seconds: 1), curve: Curves.easeOutCirc)
              ],
              child: RadialLight(size.height, size.width,
                  radius: 105, colors: [color!]),
            ),
          BookImageViewer(image: image).animate(
            effects: const [
              FadeEffect(
                curve: Curves.easeInOutQuart,
                duration: Duration(milliseconds: 500),
              )
            ],
          ),
        ],
      ),
    );
    ;
  }
}
