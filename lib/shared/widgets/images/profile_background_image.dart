import 'package:flutter/material.dart';

class ProfileBackgroundImage extends StatelessWidget {
  final ImageProvider? image;

  const ProfileBackgroundImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        image: image != null
            ? DecorationImage(image: image!, fit: BoxFit.cover)
            : null,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
