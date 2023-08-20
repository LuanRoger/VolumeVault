// ignore_for_file: constant_identifier_names

import "package:flutter/material.dart";

enum ThemeBrightness {
  light(ThemeMode.light),
  dark(ThemeMode.dark),
  system(ThemeMode.system);

  final ThemeMode themeMode;

  const ThemeBrightness(this.themeMode);
}
