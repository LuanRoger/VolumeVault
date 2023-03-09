import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';

class FetcherListGrid extends HookConsumerWidget {
  List<Widget> children;
  VisualizationType visualizationType;
  final void Function()? reachScrollBottom;
  bool isLoading;

  FetcherListGrid(
      {super.key,
      this.visualizationType = VisualizationType.LIST,
      this.reachScrollBottom,
      this.isLoading = false,
      required this.children});

  Widget _buildBookView(List<Widget> children, {ScrollController? controller}) {
    switch (visualizationType) {
      case VisualizationType.LIST:
        return ListView(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          children: children,
        );
      case VisualizationType.GRID:
        return GridView(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.5),
          children: children,
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    useEffect(
      () {
        scrollListener() {
          if (scrollController.position.maxScrollExtent !=
              scrollController.offset) return;
          reachScrollBottom?.call();
        }

        scrollController.addListener(scrollListener);

        return () => scrollController.removeListener(scrollListener);
      },
    );

    return _buildBookView(children, controller: scrollController);
  }
}
