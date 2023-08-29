import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:volume_vault/shared/widgets/fx/radial_light.dart";
import "package:volume_vault/shared/widgets/viewers/book_image_viewer.dart";

class BookShowcase extends StatelessWidget {
  final Color? color;
  final Size size;
  final ImageProvider image;
  final bool lightEffect;
  final Clip clipBehavior;
  final Alignment alignment;

  const BookShowcase({
    required this.size,
    required this.image,
    super.key,
    this.color,
    this.lightEffect = true,
    this.clipBehavior = Clip.hardEdge,
    this.alignment = Alignment.center,
  });

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
  }
}
