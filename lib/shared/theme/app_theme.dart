import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

part 'color_schemes.dart';
part 'text_themes.dart';

TextTheme get _textTheme => TextTheme(
      headlineLarge: _headlinesStyle.copyWith(fontWeight: FontWeight.bold),
      headlineMedium: _headlinesStyle,
      headlineSmall: _headlinesStyle,
      titleLarge: _titleStyle.copyWith(fontWeight: FontWeight.bold),
      titleMedium: _titleStyle,
      titleSmall: _titleStyle,
    );
InputDecorationTheme _inputDecorationTheme(BuildContext context) =>
    InputDecorationTheme(border: const OutlineInputBorder(), hintStyle: Theme.of(context).textTheme.bodyMedium);
DialogTheme _dialogTheme(BuildContext context) => DialogTheme(
      titleTextStyle: Theme.of(context).textTheme.titleLarge,
    );
AppBarTheme _appBarTheme(bool darkTheme) => AppBarTheme(
      titleTextStyle: _defaultStyle.copyWith(
        color: darkTheme ? Colors.white : Colors.black,
        fontSize: 22,
      ),
    );
ListTileThemeData get _listTileTheme => const ListTileThemeData(
      style: ListTileStyle.drawer,
    );

ThemeData lightTheme(BuildContext context) => ThemeData(
    useMaterial3: true,
    colorScheme: _lightColorScheme,
    textTheme: _textTheme,
    inputDecorationTheme: _inputDecorationTheme(context),
    dialogTheme: _dialogTheme(context),
    appBarTheme: _appBarTheme(false),
    listTileTheme: _listTileTheme);
ThemeData darkTheme(BuildContext context) => ThemeData(
    useMaterial3: true,
    colorScheme: _darkColorScheme,
    textTheme: _textTheme,
    inputDecorationTheme: _inputDecorationTheme(context),
    dialogTheme: _dialogTheme(context),
    appBarTheme: _appBarTheme(true),
    listTileTheme: _listTileTheme);
