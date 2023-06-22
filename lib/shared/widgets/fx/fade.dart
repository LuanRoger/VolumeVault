import 'package:flutter/material.dart';

class Fade extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final Rect Function(Rect)? createShaderRect;
  final Widget child;

  const Fade(
      {super.key,
      required this.child,
      this.begin = Alignment.centerRight,
      this.end = Alignment.centerLeft,
      this.createShaderRect});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        shaderCallback: (rect) => LinearGradient(
              begin: begin,
              end: end,
              colors: const [Colors.black, Colors.transparent],
            ).createShader(createShaderRect?.call(rect) ??
                Rect.fromLTRB(0, 0, rect.width * 1.5, rect.height)),
        blendMode: BlendMode.dstIn,
        child: child);
  }
}
