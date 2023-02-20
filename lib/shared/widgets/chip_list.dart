import 'package:flutter/material.dart';
import 'package:volume_vault/shared/widgets/filled_chip.dart';

class ChipList extends StatelessWidget {
  final List<String> labels;

  const ChipList(this.labels, {super.key});

  List<Widget> _generateChips(BuildContext context) {
    List<Widget> chips = List.empty(growable: true);

    for (String label in labels) {
      FilledChip chip = FilledChip(label: label);
      chips.add(chip);
    }

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _generateChips(context));
  }
}
