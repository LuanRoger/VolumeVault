import "package:flutter/material.dart";
import "package:volume_vault/shared/widgets/list_tiles/expand_tile_content.dart";

class ExpandTileText extends StatelessWidget {
  final String title;
  final TextSpan content;

  const ExpandTileText(this.title, {required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandTileContent(
      title: Text(title),
      content: Text.rich(
        content,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailingExpanded: const Icon(Icons.expand_less),
      trailingCollapsed: const Icon(Icons.expand_more),
    );
  }
}
