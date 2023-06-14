import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final ImageProvider? image;
  final String letter;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;

  const ProfileAvatar(this.letter,
      {super.key, this.image, this.padding, this.height, this.width})
      : assert(letter.length == 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: padding,
      height: height,
      width: width,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surfaceVariant),
      child: image != null
          ? Image(
              key: UniqueKey(),
              image: image!,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            )
          : Center(
              child: Text(letter,
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
    );
  }
}
