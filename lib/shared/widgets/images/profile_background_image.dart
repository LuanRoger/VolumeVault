import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
        : Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.grey[300]!,
            child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const SizedBox.expand()
          ),
          );
  }
}
