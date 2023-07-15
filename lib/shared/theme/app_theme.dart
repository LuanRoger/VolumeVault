import "package:flutter/material.dart";

part "color_schemes.dart";

InputDecorationTheme _inputDecorationTheme(BuildContext context,
        {required bool isDarkTheme}) =>
    InputDecorationTheme(
      border: const OutlineInputBorder(),
      hintStyle: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: isDarkTheme ? Colors.white : Colors.black),
    );
DialogTheme _dialogTheme(BuildContext context, {required bool isDarkTheme}) =>
    DialogTheme(
      titleTextStyle: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(color: isDarkTheme ? Colors.white : Colors.black),
    );
ListTileThemeData get _listTileTheme => const ListTileThemeData(
      style: ListTileStyle.drawer,
    );

ThemeData lightTheme(BuildContext context) => ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      inputDecorationTheme: _inputDecorationTheme(context, isDarkTheme: false),
      dialogTheme: _dialogTheme(context, isDarkTheme: false),
      listTileTheme: _listTileTheme,
    );
ThemeData darkTheme(BuildContext context) => ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      inputDecorationTheme: _inputDecorationTheme(context, isDarkTheme: true),
      dialogTheme: _dialogTheme(context, isDarkTheme: true),
      listTileTheme: _listTileTheme,
    );
