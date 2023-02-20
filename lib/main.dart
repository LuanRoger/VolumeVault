import 'package:flutter/material.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/routes/route_driver.dart';
import 'package:volume_vault/shared/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      onGenerateRoute: RouteDriver.driver,
      initialRoute: AppRoutes.homePageRoute,
    ),
  );
}
