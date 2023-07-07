import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:volume_vault/l10n/l10n.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/shared/routes/route_driver.dart';
import 'package:volume_vault/shared/theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeBrightness =
        ref.watch(themePreferencesStateProvider).themeBrightnes;
    final localizationPreferences =
        ref.watch(localizationPreferencesStateProvider);
    final routeConfig = ref.read(routeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: themeBrightness.themeMode,
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      routerConfig: routeConfig,
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        minWidth: 480,
        defaultScale: true,
        breakpoints: const [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.resize(700, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP)
        ],
      ),
      locale: localizationPreferences.localization.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: L10n.locales,
    );
  }
}
