import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/enums/api_protocol.dart';
import 'package:volume_vault/providers/providers.dart';

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
      final appPreferences = ref.read(appPreferencesProvider.notifier);
      await appPreferences.restartPreferences();
    }
  }

  void _toggleTheme(WidgetRef ref, bool newValue) {
    final appPreferences = ref.read(appPreferencesProvider.notifier);
    appPreferences.darkModePreference = newValue;
  }

  void _togglerLightEffect(WidgetRef ref, bool newValue) {
    final appPreferences = ref.read(appPreferencesProvider.notifier);
    appPreferences.lightEffect = newValue;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themePreferences = ref.watch(themePreferencesStateProvider);
    final graphicsPreferences = ref.watch(graphicsPreferencesStateProvider);
    final serverPreferences = ref.read(serverPreferencesStateProvider);
    final serverHostController =
        useTextEditingController(text: serverPreferences.serverHost);
    final serverPortController =
        useTextEditingController(text: serverPreferences.serverPort);
    final serverApiKeyController =
        useTextEditingController(text: serverPreferences.serverApiKey);
    final resetConfigLoadingState = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Text(
              "Aparencia",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surfaceTint,
                  ),
            ),
            ListTile(
              title: const Text("Tema escuro"),
              onTap: () =>
                  _toggleTheme(ref, !themePreferences.darkModePreference),
              trailing: Switch(
                  value: themePreferences.darkModePreference,
                  onChanged: (newValue) => _toggleTheme(ref, newValue)),
            ),
            Text(
              "Gráficos",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surfaceTint,
                  ),
            ),
            ListTile(
              title: const Text("Efeito de luz"),
              onTap: () =>
                  _togglerLightEffect(ref, !graphicsPreferences.lightEffect),
              trailing: Switch(
                value: graphicsPreferences.lightEffect,
                onChanged: (newValue) => _togglerLightEffect(ref, newValue),
              ),
            ),
            Text(
              "Outros",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surfaceTint,
                  ),
            ),
            Form(
              child: ExpansionTile(
                title: const Text("Avançado"),
                subtitle: const Text("Configurações do servidor e conexão"),
                children: [
                  ListTile(
                    title: TextFormField(
                      controller: serverHostController,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: "Host do servidor",
                      ),
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      controller: serverPortController,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: "Porta do servidor",
                      ),
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      controller: serverApiKeyController,
                      enabled: false,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Chave da API",
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: null, /* () {
                        final appPreferences =
                            ref.read(appPreferencesProvider.notifier);
                        appPreferences.setAllServerPref(
                            host: serverHostController.text,
                            port: serverPortController.text,
                            apiKey: serverApiKeyController.text);
                      }, */
                      child: Text("Salvar"),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: !resetConfigLoadingState.value
                  ? () async {
                      resetConfigLoadingState.value = true;
                      _resetConfiguration(context, ref);
                      resetConfigLoadingState.value = false;
                    }
                  : null,
              child: const Text("Restaurar configurações padrão"),
            )
          ],
        ),
      ),
    );
  }
}
