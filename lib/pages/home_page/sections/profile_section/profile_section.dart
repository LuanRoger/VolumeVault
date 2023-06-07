import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/pages/home_page/sections/profile_section/commands/profile_section_command.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/shared/widgets/letter_avatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileSection extends ConsumerWidget {
  final ProfileSectionCommand _commands = ProfileSectionCommand();

  ProfileSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userSessionAuthProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.profleSectionTitle), actions: [
        IconButton(
          onPressed: () => _commands.showLogoutDialog(context, ref),
          icon: const Icon(Icons.logout),
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: userInfo == null
            ? Text(AppLocalizations.of(context)!.profileSectionErrorMessage)
            : Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LetterAvatar(
                      userInfo.name[0],
                      height: 120,
                      width: 120,
                    ),
                    Text(
                      userInfo.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(userInfo.email,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const Divider(),
                  ],
                ),
              ),
      ),
    );
  }
}
