import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TextSwitch extends HookWidget {
  final String text;
  final bool value;
  final void Function(bool) onChanged;

  const TextSwitch(
      {super.key,
      required this.text,
      required this.onChanged,
      this.value = false});

  @override
  Widget build(BuildContext context) {
    final valueState = useState(value);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(text),
        Switch(
          value: valueState.value,
          onChanged: (value) {
            valueState.value = value;
            onChanged(valueState.value);
          },
        ),
      ],
    );
  }
}
