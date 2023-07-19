import "package:flutter/material.dart";
import "package:text_scroll/text_scroll.dart";

class ScrollText extends TextScroll {
  const ScrollText(super.text, {super.key, super.textAlign, super.style})
      : super(
          mode: TextScrollMode.bouncing,
          pauseBetween: const Duration(seconds: 1),
          velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
          fadedBorder: true,
          pauseOnBounce: const Duration(seconds: 2),
          fadedBorderWidth: 0.01,
          delayBefore: const Duration(seconds: 2),
        );
}
