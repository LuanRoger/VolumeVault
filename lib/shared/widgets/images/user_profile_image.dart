import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/shared/widgets/images/profile_avatar.dart';

class UserProfileImage extends HookConsumerWidget {
  final TextStyle? letterStyle;
  final double? width;
  final double? height;

  const UserProfileImage({super.key, this.letterStyle, this.height, this.width});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileStorageProvider =
        ref.watch(profileStorageBucketProvider.notifier);
    final userInfo = ref.watch(userSessionAuthProvider);

    final profileImageLoadState = useState(false);

    final profileImageMemoize =
        useMemoized(() => profileStorageProvider.getProfileImageFromBucket());

    final profileImageFuture = useFuture(profileImageMemoize);

    return userInfo != null
        ? ProfileAvatar(
            userInfo.name[0],
            width: width,
            height: height,
            isLoading: profileImageLoadState.value,
            textStyle: letterStyle,
            image: profileImageFuture.hasData
                ? FileImage(profileImageFuture.data!)
                : null,
          )
        : ProfileAvatar(
            "E",
            width: width,
            height: height,
            textStyle: letterStyle,
            letterBackgroundColor: Theme.of(context).colorScheme.error,
          );
  }
}
