import 'package:flutter/material.dart';
import 'package:volume_vault/shared/widgets/bottom_sheet/bottom_sheet_base.dart';

class BottomSheet extends BottomSheetBase {
  final List<Widget>? items;
  final Widget? content;

  BottomSheet({
    this.items,
    this.content,
    super.padding,
    super.dragable,
    super.isDismissible,
    super.isScrollControlled,
    super.action,
    super.onClose,
    super.mainAxisAlignment,
    super.crossAxisAlignment,
  }) : assert(items == null && content != null ||
            items != null && content == null);

  Future<void> show(BuildContext context) async {
    return await super.showBottomSheet(context,
        builder: (context) => content ?? Column(children: items!));
  }
}
