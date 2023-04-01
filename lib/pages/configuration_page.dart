import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/enums/theme_brightness.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/shared/widgets/text_body_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfigurationPage extends HookConsumerWidget {
  const ConfigurationPage({super.key});

  void _resetConfiguration(BuildContext context, WidgetRef ref) async {
    bool resetConfig = false;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Restaurar configurações padrão?",
            style: Theme.of(context).textTheme.titleLarge),
        content: const Text(
            "Todas as configurações serão restauradas para o padrão. Deseja continuar?"),
        actions: [
          TextButton(
            onPressed: () {
              resetConfig = false;
              Navigator.pop(context);
            },
            child: const Text("Cancelar"),
          ),
          FilledButton.tonal(
            onPressed: () {
              resetConfig = true;
              Navigator.pop(context);
            },
            child: const Text("Confirmar"),
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

  Future _showThemeChangeDialog(BuildContext context, WidgetRef ref) async {
    final themeBrightness = ref.read(themePreferencesStateProvider);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          )
        ],
        title: const Text("Tema"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Selecione o tema desejado:"),
            const SizedBox(height: 8),
            RadioListTile<ThemeBrightness>(
              title: const Text("Claro"),
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
              title: const Text("Escuro"),
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
              title: const Text("Sistema"),
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

  void _toggleLightEffect(WidgetRef ref, bool newValue) {
    final graphicsPrefernces =
        ref.read(graphicsPreferencesStateProvider.notifier);
    graphicsPrefernces.lightEffect = newValue;
  }

  void _toggleUserEnvVars(WidgetRef ref) {
    ref.read(serverConfigNotifierProvider.notifier).toggleUseEnvVars();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themePreferences = ref.watch(themePreferencesStateProvider);
    final graphicsPreferences = ref.watch(graphicsPreferencesStateProvider);

    final resetConfigLoadingState = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.configurationsAppBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextBodyTitle(AppLocalizations.of(context)!
                .aperenceSectionTitleConfigurationsPage),
            ListTile(
              title: Text(
                  AppLocalizations.of(context)!.themeOptionConfigurationsPage),
              onTap: () async => await _showThemeChangeDialog(context, ref),
              trailing: Text(themePreferences.themeBrightnes.name),
            ),
            TextBodyTitle(AppLocalizations.of(context)!
                .ghaphicsSectionTitleConfigurationsPage),
            ListTile(
              title: Text(AppLocalizations.of(context)!
                  .lightEffectOptionConfigurationsPage),
              onTap: () =>
                  _toggleLightEffect(ref, !graphicsPreferences.lightEffect),
              trailing: Switch(
                value: graphicsPreferences.lightEffect,
                onChanged: (newValue) => _toggleLightEffect(ref, newValue),
              ),
            ),
            TextBodyTitle(AppLocalizations.of(context)!
                .otherSectionTitleConfigurationsPage),
            ElevatedButton(
              onPressed: !resetConfigLoadingState.value
                  ? () async {
                      resetConfigLoadingState.value = true;
                      _resetConfiguration(context, ref);
                      resetConfigLoadingState.value = false;
                    }
                  : null,
              child: Text(AppLocalizations.of(context)!
                  .restoreDefaultConfigurationsPage),
            )
          ],
        ),
      ),
    );
  }
}
