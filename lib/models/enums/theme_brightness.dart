// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum ThemeBrightness {
  LIGHT("Claro", ThemeMode.light),
  DARK("Escuro", ThemeMode.dark),
  SYSTEM("Sistema", ThemeMode.system);

  final String name;
  final ThemeMode themeMode;

  const ThemeBrightness(this.name, this.themeMode);
}
