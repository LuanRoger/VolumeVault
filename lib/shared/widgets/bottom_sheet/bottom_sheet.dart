import 'package:flutter/material.dart';
import 'package:volume_vault/shared/widgets/bottom_sheet/bottom_sheet_base.dart';

class BottomSheet extends BottomSheetBase {
  List<Widget> items;

  BottomSheet({
    required this.items,
    super.padding,
    super.dragable,
    super.isDismissible,
    super.isScrollControlled,
    super.action,
    super.onClose,
  });

  Future<void> show(BuildContext context) async {
    return await super.showBottomSheet(context,
        builder: (context) => Column(children: items));
  }
}
