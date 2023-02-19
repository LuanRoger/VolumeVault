import 'package:flutter/material.dart';

class ListTileText extends StatelessWidget {
  String title;
  String? text;

  ListTileText({super.key, required this.title, this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Text(text ?? "-"),
    );
  }
}
