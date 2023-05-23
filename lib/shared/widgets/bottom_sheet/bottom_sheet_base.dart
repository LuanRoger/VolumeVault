import 'package:flutter/material.dart';

abstract class BottomSheetBase {
  final double padding;
  final bool dragable;
  final bool isDismissible;
  final bool isScrollControlled;
  final Widget Function(BuildContext)? action;
  final void Function()? onClose;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  BottomSheetBase(
      {this.action,
      this.padding = 8.0,
      this.dragable = false,
      this.onClose,
      this.isDismissible = false,
      this.isScrollControlled = true,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.crossAxisAlignment = CrossAxisAlignment.center});

  Future<void> showBottomSheet(BuildContext context,
      {required Widget Function(BuildContext) builder}) {
    return showModalBottomSheet(
        context: context,
        isDismissible: isDismissible,
        enableDrag: dragable,
        showDragHandle: dragable,
        isScrollControlled: isScrollControlled,
        useSafeArea: true,
        builder: (context) => Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                    mainAxisAlignment: mainAxisAlignment,
                    crossAxisAlignment: crossAxisAlignment,
                    children: [
                      Row(
                        mainAxisAlignment: dragable
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          if (!dragable)
                            IconButton(
                                onPressed: () {
                                  onClose?.call();
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.close_rounded)),
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
