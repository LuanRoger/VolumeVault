import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import "package:volume_vault/models/user_badge_model.dart";
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/widgets/bottom_sheet/image_source_selector.dart';

abstract class ProfileCardStrategy {
  Future<void> showLogoutDialog(BuildContext context, WidgetRef ref) async {
    bool exit = false;

    await showDialog<void>(
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

  Future<void> changeProfileImage(BuildContext context, WidgetRef ref) async {
    ImageSourceSelector selector = ImageSourceSelector();
    final selectedSource = await selector.show(context);
    if (selectedSource == null) return;

    final profileStorageProvider =
        ref.read(profileStorageBucketProvider.notifier);
    final ImagePicker imagePicker = ImagePicker();
    final XFile? profileImage =
        await imagePicker.pickImage(source: selectedSource);
    if (profileImage == null) return;

    final File imageFile = File(profileImage.path);
    await profileStorageProvider.uploadProfileImage(imageFile);
  }

  Future<void> changeProfileBackground(
      BuildContext context, WidgetRef ref) async {
    ImageSourceSelector selector = ImageSourceSelector();
    final selectedSource = await selector.show(context);
    if (selectedSource == null) return;

    final profileStorageProvider =
        ref.read(profileStorageBucketProvider.notifier);
    final ImagePicker backgroundPicker = ImagePicker();
    final XFile? backgroundImage =
        await backgroundPicker.pickImage(source: selectedSource);
    if (backgroundImage == null) return;

    final File imageFile = File(backgroundImage.path);
    await profileStorageProvider.uploadBackgroundImage(imageFile);
  }

  Future<UserBadgeModel?> getUserBadges(
      BuildContext context, WidgetRef ref) async {
    final userSession = ref.read(userSessionAuthProvider);
    final badgeController = await ref.read(badgeControllerProvider.future);
    if (userSession == null) return null;

    final userBadgeModel = await badgeController.getUserBadges(userSession.uid);
    return userBadgeModel;
  }
}
