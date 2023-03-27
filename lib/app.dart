import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/routes/route_driver.dart';
import 'package:volume_vault/shared/theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeBrightness =
        ref.watch(themePreferencesStateProvider).themeBrightnes;
    final userSession = ref.watch(userSessionNotifierProvider);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: themeBrightness.themeMode,
        theme: lightTheme(context),
        darkTheme: darkTheme(context),
        onGenerateRoute: RouteDriver.driver,
        initialRoute: userSession.maybeWhen(
            data: (userSession) => userSession.token.isEmpty
                ? AppRoutes.loginPageRoute
                : AppRoutes.homePageRoute,
            orElse: () => AppRoutes.loginPageRoute),
        builder: (context, child) => ResponsiveWrapper.builder(
              child,
              minWidth: 480,
              defaultScale: true,
              breakpoints: const [
                ResponsiveBreakpoint.resize(480, name: MOBILE),
                ResponsiveBreakpoint.autoScale(700, name: TABLET),
                ResponsiveBreakpoint.resize(1000, name: DESKTOP)
              ],
            ));
  }
}
