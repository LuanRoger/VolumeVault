import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';

class ProfileSectionStrategy {
  Future<void> showLogoutDialog(BuildContext context, WidgetRef ref) async {
    bool exit = false;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.signoutDialogTitle),
          content: Text(AppLocalizations.of(context)!.signoutDialogMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancelDialogButton),
            ),
            TextButton(
              onPressed: () {
                exit = true;
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.exitDialogButton),
            ),
          ]),
    );

    if (exit) {
      await ref.read(userSessionAuthProvider.notifier).logout();

      context.go(AppRoutes.loginSigninPage);
    }
  }

  Future<void> changeProfileBackground(WidgetRef ref) async {
    final profileStorageProvider =
        ref.read(profileStorageBucketProvider.notifier);
    final ImagePicker backgroundPicker = ImagePicker();
    final XFile? backgroundImage =
        await backgroundPicker.pickImage(source: ImageSource.gallery);
    if (backgroundImage == null) return;

    final File imageFile = File(backgroundImage.path);
    await profileStorageProvider.uploadBackgroundImage(imageFile);
  }

  Future<void> changeProfileImage(WidgetRef ref) async {
    final profileStorageProvider =
        ref.read(profileStorageBucketProvider.notifier);
    final ImagePicker imagePicker = ImagePicker();
    final XFile? backgroundImage =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (backgroundImage == null) return;

    final File imageFile = File(backgroundImage.path);
    await profileStorageProvider.uploadProfileImage(imageFile);
  }
}
