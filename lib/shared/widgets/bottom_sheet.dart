import 'package:flutter/material.dart';

class BottomSheet {
  List<Widget> items;
  double padding;
  Widget Function(BuildContext)? action;
  bool dragable;
  void Function()? onClose;

  BottomSheet(
      {required this.items,
      this.action,
      this.padding = 8.0,
      this.dragable = false,
      this.onClose});

  Future show(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: dragable,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            onClose?.call();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close_rounded)),
                      if (dragable) const _DragIndicator(),
                      action?.call(context) ?? const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ...items
                ],
              ),
            ),
          );
        });
  }
}

class _DragIndicator extends StatelessWidget {
  const _DragIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: 32,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color:
              Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4)),
    );
  }
}
