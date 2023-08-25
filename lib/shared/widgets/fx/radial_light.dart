import "package:eeffects/eeffects.dart";
import "package:flutter/material.dart";

class RadialLight extends StatelessWidget {
  final double height;
  final double width;
  List<Color> colors;
  double sceneXPoss;
  double sceneYPoss;
  double radius;

  RadialLight(
    this.height,
    this.width, {
    required this.colors,
    super.key,
    this.sceneXPoss = 0,
    this.sceneYPoss = 0,
    this.radius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return EScene(
      height: height,
      width: width,
      darkness: EColorShift([Colors.white.withOpacity(0)], 0),
      effects: [
        ERadialLight(
            ERelativePos(0.5, 0.5),
            ERelative(radius, ERelative.absolute),
            EGradient([EColorShift(colors, 0)]),
            0,
            0,
            ERelative(30, ERelative.absolute),
            ERelative(0, ERelative.absolute),
            0.1,
            1),
      ],
      afterUpdate: () {},
      beforeUpdate: () {},
    );
  }
}
