import "package:flutter/material.dart";
import "package:volume_vault/shared/widgets/bottom_sheet/bottom_sheet_base.dart";

class StatefulBottomSheet extends BottomSheetBase {
  Widget Function(BuildContext, void Function(void Function())) child;

  StatefulBottomSheet({
    required this.child,
    super.dragable,
    super.isDismissible,
    super.isScrollControlled,
    super.padding,
    super.action,
    super.onClose,
    super.mainAxisAlignment,
    super.crossAxisAlignment,
  });

  Future<void> show(BuildContext context) async {
    return super.showBottomSheet(
      context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => child(context, setState),
      ),
    );
  }
}
