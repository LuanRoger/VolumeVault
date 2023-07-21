import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class ExpandTileContent extends HookWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget content;
  final Widget? trailingExpanded;
  final Widget? trailingCollapsed;

  const ExpandTileContent(
      {required this.title,
      required this.content,
      super.key,
      this.subtitle,
      this.trailingExpanded,
      this.trailingCollapsed});

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(false);

    return ExpansionTile(
      title: title,
      subtitle: subtitle,
      trailing: isExpanded.value ? trailingExpanded : trailingCollapsed,
      children: [content],
      onExpansionChanged: (newValue) => isExpanded.value = newValue,
    );
  }
}
