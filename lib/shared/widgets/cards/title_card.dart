import "package:flutter/material.dart";
import "package:volume_vault/shared/theme/text_themes.dart";

class TitleCard extends StatelessWidget {
  final Widget title;
  final Widget content;
  final bool expand;

  const TitleCard({
    required this.title,
    required this.content,
    super.key,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expand ? double.infinity : null,
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(
                  style: titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  ),
                  child: title),
              const SizedBox(height: 5),
              content
            ],
          ),
        ),
      ),
    );
  }
}
