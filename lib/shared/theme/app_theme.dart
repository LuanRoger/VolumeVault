import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

part 'color_schemes.dart';
part 'text_themes.dart';

TextTheme get _textTheme => TextTheme(
    headlineLarge:
        _headlinesStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
    headlineMedium: _headlinesStyle.copyWith(fontSize: 14),
    headlineSmall: _headlinesStyle.copyWith(fontSize: 12),
    displayLarge: _displayStyle.copyWith(fontSize: 16),
    displayMedium: _displayStyle.copyWith(fontSize: 14),
    displaySmall: _displayStyle.copyWith(fontSize: 12));
InputDecorationTheme get _inputDecorationTheme =>
    const InputDecorationTheme(border: OutlineInputBorder());

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _lightColorScheme,
  textTheme: _textTheme,
  inputDecorationTheme: _inputDecorationTheme,
);
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _darkColorScheme,
  textTheme: _textTheme,
  inputDecorationTheme: _inputDecorationTheme,
);
