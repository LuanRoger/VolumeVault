import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WidgetSwitcher extends StatelessWidget {
  final Widget first;
  final Widget second;

  const WidgetSwitcher({super.key, required this.first, required this.second});

  @override
  Widget build(BuildContext context) {
    const curveIn = Curves.easeInExpo;
    const curveOut = Curves.easeOutExpo;

    return first
        .animate()
        .fadeIn(curve: curveIn)
        .then(delay: const Duration(seconds: 3))
        .fadeOut(curve: curveOut)
        .swap(
      builder: (_, child) {
        return second
            .animate()
            .fadeIn(curve: curveIn)
            .then(delay: const Duration(seconds: 5))
            .fadeOut(curve: curveOut)
            .swap(builder: (_, __) => child!.animate().fadeIn());
      },
    );
  }
}
