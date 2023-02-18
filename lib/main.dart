import 'package:flutter/material.dart';
import 'package:volume_vault/pages/home_page/home_page.dart';
import 'package:volume_vault/shared/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
    ),
  );
}
