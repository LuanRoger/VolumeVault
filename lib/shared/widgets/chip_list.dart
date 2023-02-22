import 'package:flutter/material.dart';
import 'package:volume_vault/shared/widgets/filled_chip.dart';

class ChipList extends StatelessWidget {
  final Set<String> labels;
  final double spacing;
  final void Function(String)? onRemove;

  const ChipList(this.labels, {super.key, this.spacing = 10.0, this.onRemove});

  List<Widget> _generateChips(BuildContext context) {
    List<Widget> chips = List.empty(growable: true);
    for (String label in labels) {
      final bool isLast = label == labels.last;
      Widget chip = onRemove != null
          ? InputChip(
              label: Text(label),
              deleteIcon: const Icon(Icons.close_rounded),
              onDeleted: () => onRemove!(label),
            )
          : FilledChip(label: label);

      chips.add(chip);
      if (!isLast) chips.add(SizedBox(width: spacing));
    }

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: _generateChips(context));
  }
}
