import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SearchTextField extends HookWidget {
  double? width;
  double? height;
  String? label;

  final TextEditingController controller;

  SearchTextField(
      {super.key,
      required this.controller,
      this.width,
      this.height,
      this.label});

  @override
  Widget build(BuildContext context) {
    useListenable(controller);

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search_rounded),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none),
        hintText: label,
        filled: true,
        isDense: true,
        contentPadding: const EdgeInsets.all(8.0),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.delete),
                onPressed: controller.clear,
              )
            : null,
      ),
    );
  }
}
