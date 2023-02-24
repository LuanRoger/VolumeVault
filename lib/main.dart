import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/shared/preferences/app_preferences.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/routes/route_driver.dart';
import 'package:volume_vault/shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appPreferences = AppPreferences(await SharedPreferences.getInstance());
  await appPreferences.loadPreferences();

  runApp(
    ProviderScope(overrides: [
      appPreferencesProvider.overrideWith((_) => appPreferences),
    ], child: const App()),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeBrightness =
        ref.watch(themePreferencesStateProvider).themeBrightnes;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeBrightness.themeMode,
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      onGenerateRoute: RouteDriver.driver,
      initialRoute: AppRoutes.homePageRoute,
    );
  }
}
