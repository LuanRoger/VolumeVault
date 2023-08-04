import 'package:flutter/material.dart';
import "package:volume_vault/shared/widgets/fx/shimmer_effect.dart";

class ProfileBackgroundImage extends StatelessWidget {
  final ImageProvider? image;
  final bool isLoading;

  const ProfileBackgroundImage(
      {super.key, required this.image, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              image: image != null
                  ? DecorationImage(image: image!, fit: BoxFit.cover)
                  : null,
              borderRadius: BorderRadius.circular(10),
            ),
          )
        : const ShimmerEffect();
  }
}
