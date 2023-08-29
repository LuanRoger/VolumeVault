import "package:flutter/material.dart";

class RadioText<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final void Function(T?) onChanged;
  final String text;

  const RadioText({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        const SizedBox(width: 5),
        Text(text),
      ],
    );
  }
}
