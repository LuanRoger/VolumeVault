import 'package:flutter/material.dart';
import 'package:volume_vault/shared/widgets/bottom_sheet/drag_indicator.dart';

abstract class BottomSheetBase {
  final double padding;
  final bool dragable;
  final bool isDismissible;
  final bool isScrollControlled;
  final Widget Function(BuildContext)? action;
  final void Function()? onClose;

  BottomSheetBase(
      {this.action,
      this.padding = 8.0,
      this.dragable = false,
      this.onClose,
      this.isDismissible = false,
      this.isScrollControlled = true});

  Future<void> showBottomSheet(BuildContext context,
      {required Widget Function(BuildContext) builder}) {
    return showModalBottomSheet(
        context: context,
        isDismissible: isDismissible,
        enableDrag: dragable,
        isScrollControlled: isScrollControlled,
        useSafeArea: true,
        builder: (context) => Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            onClose?.call();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close_rounded)),
                      if (dragable) const DragIndicator(),
                      action?.call(context) ?? const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 15),
                  builder(context)
                ]),
              ),
            ));
  }
}
