import 'package:flutter/material.dart';

class ConfigurationPage extends StatelessWidget {
  const ConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              trailing: Switch(value: true, onChanged: (value) {}),
            ),
            Text(
              "Outros",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surfaceTint,
                  ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Restaurar configurações padrão"),
            )
          ],
        ),
      ),
    );
  }
}
