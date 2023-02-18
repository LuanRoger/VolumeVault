import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

part 'color_schemes.dart';
part 'text_themes.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _lightColorScheme,
  textTheme: TextTheme(
      titleLarge: _titlesStyle.copyWith(fontSize: 20),
      titleMedium: _titlesStyle.copyWith(fontSize: 18),
      titleSmall: _titlesStyle.copyWith(fontSize: 14),
      headlineLarge: _headlinesStyle.copyWith(fontSize: 14),
      headlineMedium: _headlinesStyle.copyWith(fontSize: 12),
      headlineSmall: _headlinesStyle.copyWith(fontSize: 10),
      displayLarge: _displayStyle.copyWith(fontSize: 16),
      displayMedium: _displayStyle.copyWith(fontSize: 14),
      displaySmall: _displayStyle.copyWith(fontSize: 12)),
);
ThemeData darkTheme =
    ThemeData(useMaterial3: true, colorScheme: _darkColorScheme);
