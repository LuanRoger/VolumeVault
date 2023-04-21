import 'package:flutter/material.dart';

class RadioText extends StatelessWidget {
  final dynamic value;
  final dynamic groupValue;
  final dynamic onChanged;
  final String text;

  const RadioText(
      {super.key,
      required this.value,
      required this.groupValue,
      required this.onChanged,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
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
