import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:volume_vault/l10n/supported_locales.dart';
import 'package:volume_vault/models/enums/theme_brightness.dart';
import 'package:volume_vault/providers/providers.dart';

abstract class ConfigurationPageStrategy {
  void resetConfiguration(BuildContext context, WidgetRef ref) async {
    bool resetConfig = false;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            AppLocalizations.of(context)!
                .restoreDefaultConfigurationsDialogTitle,
            style: Theme.of(context).textTheme.titleLarge),
        content: Text(AppLocalizations.of(context)!
            .restoreDefaultConfigurationsDialogMessage),
        actions: [
          TextButton(
            onPressed: () {
              resetConfig = false;
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.cancelDialogButton),
          ),
          FilledButton.tonal(
            onPressed: () {
              resetConfig = true;
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.confirmDialogButton),
          ),
        ],
      ),
    );

    if (resetConfig) {
      final themePreferences = ref.read(themePreferencesStateProvider.notifier);
      final graphicsPreferences =
          ref.read(graphicsPreferencesStateProvider.notifier);

      themePreferences.reset();
      graphicsPreferences.reset();
    }
  }

  Future showThemeChangeDialog(BuildContext context, WidgetRef ref) async {
    final themeBrightness = ref.read(themePreferencesStateProvider);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancelDialogButton),
          )
        ],
        title: Text(AppLocalizations.of(context)!.themeSelectionDialogTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.themeSelectionDialogMessage),
            const SizedBox(height: 8),
            RadioListTile<ThemeBrightness>(
              title: Text(AppLocalizations.of(context)!
                  .lightThemeSelectionDialogOption),
              value: ThemeBrightness.LIGHT,
              groupValue: themeBrightness.themeBrightnes,
              onChanged: (newValue) {
                if (newValue == null) return;

                ref
                    .read(themePreferencesStateProvider.notifier)
                    .themeBrightness = newValue;
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeBrightness>(
              title: Text(
                  AppLocalizations.of(context)!.darkThemeSelectionDialogOption),
              value: ThemeBrightness.DARK,
              groupValue: themeBrightness.themeBrightnes,
              onChanged: (newValue) {
                if (newValue == null) return;

                ref
                    .read(themePreferencesStateProvider.notifier)
                    .themeBrightness = newValue;
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeBrightness>(
              title: Text(AppLocalizations.of(context)!
                  .systemThemeSelectionDialogOption),
              value: ThemeBrightness.SYSTEM,
              groupValue: themeBrightness.themeBrightnes,
              onChanged: (newValue) {
                if (newValue == null) return;

                ref
                    .read(themePreferencesStateProvider.notifier)
                    .themeBrightness = newValue;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void toggleLightEffect(WidgetRef ref, bool newValue) {
    final graphicsPrefernces =
        ref.read(graphicsPreferencesStateProvider.notifier);
    graphicsPrefernces.lightEffect = newValue;
  }

  void changeLanguage(WidgetRef ref, SupportedLocales newLocale) {
    final localizationPreferences =
        ref.read(localizationPreferencesStateProvider.notifier);
    localizationPreferences.changeLocalization(newLocale);
  }
}
