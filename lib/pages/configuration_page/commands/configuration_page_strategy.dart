import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:volume_vault/l10n/supported_locales.dart";
import "package:volume_vault/models/enums/theme_brightness.dart";
import "package:volume_vault/providers/providers.dart";

abstract class ConfigurationPageStrategy {
  Future<void> resetConfiguration(BuildContext context, WidgetRef ref) async {
    var resetConfig = false;

    await showDialog<void>(
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

  Future<void> showThemeChangeDialog(
      BuildContext context, WidgetRef ref) async {
    final themeBrightness = ref.read(themePreferencesStateProvider);

    await showDialog<void>(
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
              value: ThemeBrightness.light,
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
              value: ThemeBrightness.dark,
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
              value: ThemeBrightness.system,
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

  void toggleLightEffect(WidgetRef ref, {required bool newValue}) {
    ref.read(graphicsPreferencesStateProvider.notifier).lightEffect = newValue;
  }

  void changeLanguage(WidgetRef ref, SupportedLocales newLocale) {
    ref
        .read(localizationPreferencesStateProvider.notifier)
        .changeLocalization(newLocale);
  }
}
