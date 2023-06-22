import 'package:flutter/material.dart';

class LinearVinheta extends StatelessWidget {
  final Color startColor;
  final Color endColor;

  const LinearVinheta(
      {super.key,
      this.startColor = Colors.transparent,
      this.endColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 1]),
      ),
    );
  }
}
