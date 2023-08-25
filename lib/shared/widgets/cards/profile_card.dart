import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:volume_vault/providers/providers.dart";
import "package:volume_vault/shared/theme/text_themes.dart";
import "package:volume_vault/shared/ui_utils/snackbar_utils.dart";
import "package:volume_vault/shared/widgets/badges/badges_showcase_container.dart";
import "package:volume_vault/shared/widgets/badges/premium_badge.dart";
import "package:volume_vault/shared/widgets/badges/verified_badge.dart";
import "package:volume_vault/shared/widgets/buttons/expanded_elevated_button.dart";
import "package:volume_vault/shared/widgets/commands/profile_card_command/profile_card_command.dart";
import "package:volume_vault/shared/widgets/dialogs/content_dialog.dart";
import "package:volume_vault/shared/widgets/images/circular_border_padding.dart";
import "package:volume_vault/shared/widgets/images/profile_avatar.dart";
import "package:volume_vault/shared/widgets/images/profile_background_image.dart";

class ProfileCard {
  final double? heightFactor;
  final double? widthFactor;

  const ProfileCard({this.heightFactor, this.widthFactor});

  Future<void> show(BuildContext context) async {
    final profileCardDialog = ContentDialog(
      widthFactor: widthFactor ?? 1.3,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.topCenter,
      borderRadius: 10,
      content: _ProfileCard(),
    );

    await profileCardDialog.show(context);
  }
}

class _ProfileCard extends HookConsumerWidget {
  final ProfileCardCommand _command = ProfileCardCommand();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userSessionAuthProvider);

    final profileStorageProvider =
        ref.watch(profileStorageBucketProvider.notifier);

    final profileImageLoadState = useState(false);
    final profileBackgroundImageLoadState = useState(false);
    final cardControllerLoading = useState(false);

    final profileImageMemoize =
        useMemoized(profileStorageProvider.getProfileImageFromBucket);
    final profileBackgroundImageMemoize =
        useMemoized(profileStorageProvider.getProfileBackgroundImageFromBucket);
    final userBadgesRefreshKey = useState(UniqueKey());
    final userBadgesMemoize = useMemoized(
        () => _command.getUserBadges(context, ref),
        [userBadgesRefreshKey.value]);
    final badgeToClaimMemoize = useMemoized(
        () => _command.getBadgeInArchive(ref), [userBadgesRefreshKey.value]);

    final profileImageFuture = useFuture(profileImageMemoize);
    final profileBackgroundImageFuture =
        useFuture(profileBackgroundImageMemoize);
    final userBadgesFuture = useFuture(userBadgesMemoize);
    final badgeToClaimFuture = useFuture(badgeToClaimMemoize);

    useEffect(() {
      imageCache.clearLiveImages();

      return null;
    }, [profileImageLoadState.value, profileBackgroundImageLoadState.value]);

    final showClaimBadgeButton = badgeToClaimFuture.hasData &&
        badgeToClaimFuture.data != null &&
        badgeToClaimFuture.data!.count > 0;

    return userInfo == null
        ? Text(AppLocalizations.of(context)!.profileSectionErrorMessage)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    ProfileBackgroundImage(
                      isLoading: profileBackgroundImageLoadState.value,
                      image: profileBackgroundImageFuture.hasData
                          ? FileImage(profileBackgroundImageFuture.data!)
                          : null,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () async {
                              profileBackgroundImageLoadState.value = true;
                              await _command.changeProfileBackground(
                                  context, ref);
                              profileBackgroundImageLoadState.value = false;
                            },
                            icon: const Icon(Icons.edit_rounded),
                          ),
                          IconButton(
                            onPressed: () =>
                                _command.showLogoutDialog(context, ref),
                            icon: const Icon(Icons.logout_rounded),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: -50,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () async {
                            profileImageLoadState.value = true;
                            await _command.changeProfileImage(context, ref);
                            profileImageLoadState.value = false;
                          },
                          child: CircularBorderPadding(
                            padding: 5,
                            child: ProfileAvatar(
                              userInfo.name[0],
                              height: 130,
                              width: 130,
                              isLoading: profileImageLoadState.value,
                              image: profileImageFuture.hasData
                                  ? FileImage(profileImageFuture.data!)
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 0,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (userBadgesFuture.hasData &&
                            userBadgesFuture.data!.count > 0)
                          BadgesShowcaseContainer(
                              badgesCodes: userBadgesFuture.data!.badges),
                        const SizedBox(width: 10),
                        const PremiumBadge(),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 0,
                      child: Row(
                        children: [
                          Text(
                            userInfo.name,
                            style: titleLarge.copyWith(
                                fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                          ),
                          const SizedBox(width: 5),
                          VerifierdBadge(isVerified: userInfo.verified),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 0,
                      child: Text(userInfo.email,
                          style: Theme.of(context).textTheme.bodyLarge),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 0,
                child: Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: cardControllerLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (showClaimBadgeButton)
                                Flexible(
                                  flex: 0,
                                  child: Badge(
                                    label: Text(badgeToClaimFuture.data!.count
                                        .toString()),
                                    child: ExpandedElevatedButton(
                                      onPressed: () async {
                                        cardControllerLoading.value = true;
                                        final success = await _command
                                            .claimCurrentUserBadgesOnArchive(
                                                ref);

                                        // ignore: use_build_context_synchronously
                                        if (!context.mounted) return;
                                        if (!success) {
                                          SnackbarUtils
                                              .showErrorBadgeClaimSnackbar(
                                                  context);
                                          cardControllerLoading.value = false;
                                          return;
                                        }

                                        userBadgesRefreshKey.value =
                                            UniqueKey();
                                        cardControllerLoading.value = false;
                                      },
                                      child: Text(AppLocalizations.of(context)!
                                          .claimBadgesUserButtonMessage),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          );
  }
}
