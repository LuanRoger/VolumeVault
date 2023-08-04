import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:lucide_icons/lucide_icons.dart";
import "package:url_launcher/url_launcher.dart";
import "package:volume_vault/providers/values_provider.dart";

class GithubIconButton extends ConsumerWidget {
  const GithubIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socialMediaUrl = ref.read(socialMediaUrlProvider);
    final githubUrl = Uri.parse(socialMediaUrl[0]);

    return IconButton(
      onPressed: () async =>
          launchUrl(githubUrl, mode: LaunchMode.externalApplication),
      icon: const Icon(LucideIcons.github),
    );
  }
}

class LinkedinIconButton extends ConsumerWidget {
  const LinkedinIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socialMediaUrl = ref.read(socialMediaUrlProvider);
    final linkedinUrl = Uri.parse(socialMediaUrl[1]);

    return IconButton(
      onPressed: () async =>
          launchUrl(linkedinUrl, mode: LaunchMode.externalApplication),
      icon: const Icon(LucideIcons.linkedin),
    );
  }
}
