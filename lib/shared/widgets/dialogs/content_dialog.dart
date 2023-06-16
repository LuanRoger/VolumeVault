import 'package:flutter/material.dart';

class ContentDialog {
  final EdgeInsetsGeometry padding;
  final Alignment alignment;
  final Widget Function(BuildContext context)? builder;
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final bool closeButton;
  final double heightFactor;
  final double widthFactor;
  final double borderRadius;

  const ContentDialog({
    this.content,
    this.builder,
    this.title,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.center,
    this.actions,
    this.borderRadius = 8.0,
    this.closeButton = false,
    this.heightFactor = 0.5,
    this.widthFactor = 0.5,
  }) : assert(builder != null && content == null ||
            builder == null && content != null);

  Dialog _buildDialog(BuildContext context, {Size? size}) {
    return Dialog(
      alignment: alignment,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        padding: padding,
        height: size?.height,
        width: size?.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  title ?? const SizedBox(),
                  if (closeButton)
                    IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),
            Expanded(flex: 10, child: content!),
            if (actions != null)
              ...(() {
                return [
                  const Spacer(),
                  Flexible(
                    flex: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: actions!,
                    ),
                  )
                ];
              }())
          ],
        ),
      ),
    );
  }

  Future<void> show(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width * widthFactor;
    final height = size.height * heightFactor;

    return showDialog(
      context: context,
      builder: builder ??
          (context) => _buildDialog(
                context,
                size: Size(width, height),
              ),
    );
  }
}
