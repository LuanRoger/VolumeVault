import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  double? width;
  double? height;

  SearchTextField({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none),
          filled: true,
          isDense: true,
          contentPadding: EdgeInsets.all(8.0)),
    );
  }
}
