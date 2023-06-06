import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/pages/home_page/sections/profile_section/commands/profile_section_command.dart';
import 'package:volume_vault/providers/providers.dart';

class ProfileSection extends ConsumerWidget {
  final ProfileSectionCommand _commands = ProfileSectionCommand();

  ProfileSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userSessionAuthProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Perfil"), actions: [
        IconButton(
          onPressed: () => _commands.showLogoutDialog(context, ref),
          icon: const Icon(Icons.logout),
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: userInfo == null
            ? Text(
                "This could not be possible",
                style: TextStyle(),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      userInfo.name,
                      style: Theme.of(context).textTheme.displayLarge,
                      textAlign: TextAlign.center,
                    ),
                    Text(userInfo.email,
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
      ),
    );
  }
}
