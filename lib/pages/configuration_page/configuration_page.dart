import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import "package:go_router/go_router.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:volume_vault/l10n/l10n_utils.dart";
import 'package:volume_vault/l10n/supported_locales.dart';
import 'package:volume_vault/pages/configuration_page/commands/configuration_page_commands.dart';
import 'package:volume_vault/providers/providers.dart';
import "package:volume_vault/shared/routes/app_routes.dart";
import 'package:volume_vault/shared/widgets/texts/text_body_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfigurationPage extends StatelessWidget {
  const ConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Text(AppLocalizations.of(context)!.configurationsAppBarTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.help),
                onPressed: () => context.push(AppRoutes.aboutPageRoute),
              )
            ]),
        body: ConfigurationContent());
  }
}

class ConfigurationContent extends HookConsumerWidget {
  final ConfigurationPageCommands _commands = ConfigurationPageCommands();
  final double padding;

  ConfigurationContent({super.key, this.padding = 8.0});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themePreferences = ref.watch(themePreferencesStateProvider);
    final graphicsPreferences = ref.watch(graphicsPreferencesStateProvider);
    final localizationPreferences =
        ref.watch(localizationPreferencesStateProvider);

    final resetConfigLoadingState = useState(false);

    return Padding(
      padding: EdgeInsets.all(padding),
      child: ListView(
        children: [
          TextBodyTitle(AppLocalizations.of(context)!
              .aperenceSectionTitleConfigurationsPage),
          ListTile(
            title: Text(
                AppLocalizations.of(context)!.themeOptionConfigurationsPage),
            onTap: () async => _commands.showThemeChangeDialog(context, ref),
            trailing: Text(
              localizeTheme(
                context,
                brightness: themePreferences.themeBrightnes,
              ),
            ),
          ),
          TextBodyTitle(AppLocalizations.of(context)!
              .ghaphicsSectionTitleConfigurationsPage),
          ListTile(
            title: Text(AppLocalizations.of(context)!
                .lightEffectOptionConfigurationsPage),
            onTap: () => _commands.toggleLightEffect(
                ref, !graphicsPreferences.lightEffect),
            trailing: Switch(
              value: graphicsPreferences.lightEffect,
              onChanged: (newValue) =>
                  _commands.toggleLightEffect(ref, newValue),
            ),
          ),
          TextBodyTitle(AppLocalizations.of(context)!
              .languageSectionTitleConfigurationsPage),
          DropdownButtonFormField<SupportedLocales>(
            value: localizationPreferences.localization,
            style: Theme.of(context).textTheme.bodyMedium,
            items: const [
              DropdownMenuItem(
                value: SupportedLocales.ptBR,
                child: Text("Português"),
              ),
              DropdownMenuItem(
                value: SupportedLocales.enUS,
                child: Text("English"),
              ),
            ],
            onChanged: (newValue) {
              if (newValue == null) return;
              _commands.changeLanguage(ref, newValue);
            },
          ),
          TextBodyTitle(AppLocalizations.of(context)!
              .otherSectionTitleConfigurationsPage),
          ElevatedButton(
            onPressed: !resetConfigLoadingState.value
                ? () async {
                    resetConfigLoadingState.value = true;
                    _commands.resetConfiguration(context, ref);
                    resetConfigLoadingState.value = false;
                  }
                : null,
            child: Text(
                AppLocalizations.of(context)!.restoreDefaultConfigurationsPage),
          )
        ],
      ),
    );
  }
}
