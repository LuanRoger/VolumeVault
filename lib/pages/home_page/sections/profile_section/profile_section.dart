import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/pages/home_page/sections/profile_section/commands/profile_section_command.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/shared/widgets/badges/premium_badge.dart';
import 'package:volume_vault/shared/widgets/images/profile_avatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:volume_vault/shared/widgets/images/profile_background_image.dart';
import 'package:volume_vault/shared/widgets/images/transparent_circular_border.dart';

class ProfileSection extends HookConsumerWidget {
  final ProfileSectionCommand _commands = ProfileSectionCommand();

  ProfileSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userSessionAuthProvider);
    final profileStorageProvider =
        ref.watch(profileStorageBucketProvider.notifier);

    final profileImageLoadState = useState(false);
    final profileBackgroundImageLoadState = useState(false);

    final profileImageMemoize =
        useMemoized(() => profileStorageProvider.getProfileImageFromBucket());
    final profileBackgroundImageMemoize = useMemoized(
        () => profileStorageProvider.getProfileBackgroundImageFromBucket());

    final profileImageFuture = useFuture(profileImageMemoize);
    final profileBackgroundImageFuture =
        useFuture(profileBackgroundImageMemoize);

    useEffect(() {
      imageCache.clearLiveImages();

      return null;
    }, [profileImageLoadState.value, profileBackgroundImageLoadState.value]);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: userInfo == null
            ? Text(AppLocalizations.of(context)!.profileSectionErrorMessage)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
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
                                onPressed: () {
                                  profileBackgroundImageLoadState.value = true;
                                  _commands.changeProfileBackground(ref);
                                  profileBackgroundImageLoadState.value = false;
                                },
                                icon: const Icon(Icons.edit_rounded),
                              ),
                              IconButton(
                                onPressed: () =>
                                    _commands.showLogoutDialog(context, ref),
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
                                await _commands.changeProfileImage(ref);
                                profileImageLoadState.value = false;
                              },
                              child: TransparentCircularBorder(
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
                        child: const PremiumBadge(),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    flex: 4,
                    child: Text(
                      userInfo.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Text(userInfo.email,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  const Divider()
                ],
              ),
      ),
    );
  }
}
