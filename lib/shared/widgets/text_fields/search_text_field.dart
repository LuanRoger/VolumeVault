import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class SearchTextField extends HookWidget {
  final List<Widget>? trailing;
  final double? width;
  final double? height;
  final String? label;
  final bool showClearButton;

  final TextEditingController controller;

  const SearchTextField({
    required this.controller,
    super.key,
    this.trailing,
    this.width,
    this.height,
    this.label,
    this.showClearButton = true,
  });

  @override
  Widget build(BuildContext context) {
    useListenable(controller);

    return SearchBar(
        controller: controller,
        hintText: label,
        elevation: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.focused) ||
              states.contains(MaterialState.hovered)) return 3.0;

          return 0.5;
        }),
        trailing: [
          ...?trailing,
          if (showClearButton)
            IconButton(
              icon: const Icon(Icons.backspace_rounded),
              onPressed: controller.clear,
            )
        ]);
  }
}
