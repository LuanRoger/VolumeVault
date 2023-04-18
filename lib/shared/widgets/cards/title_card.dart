import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget {
  Widget title;
  Widget content;
  bool expand;

  TitleCard(
      {super.key,
      required this.title,
      required this.content,
      this.expand = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme.titleLarge!;

    return SizedBox(
      width: expand ? double.infinity : null,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(style: theme, child: title),
              const SizedBox(height: 5),
              content
            ],
          ),
        ),
      ),
    );
  }
}