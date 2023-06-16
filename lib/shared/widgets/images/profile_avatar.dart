import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileAvatar extends StatelessWidget {
  final ImageProvider? image;
  final String letter;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final bool isLoading;

  const ProfileAvatar(this.letter,
      {super.key,
      this.image,
      this.padding,
      this.height,
      this.width,
      this.isLoading = false})
      : assert(letter.length == 1);

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Container(
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
          )
        : Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.grey[300]!,
            child: Container(
              padding: padding,
              height: height,
              width: width,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.surfaceVariant),
              child: const SizedBox.expand(),
            ),
          );
  }
}
