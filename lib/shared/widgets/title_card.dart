import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget {
  String title;
  String content;
  bool expand;

  TitleCard(
      {super.key,
      required this.title,
      required this.content,
      this.expand = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expand ? double.infinity : null,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 5),
              Text(content)
            ],
          ),
        ),
      ),
    );
  }
}
