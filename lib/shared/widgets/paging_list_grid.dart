import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/shared/widgets/placeholders/no_registered_book_placeholder.dart';

class PagingListGrid<T, K> extends StatelessWidget {
  final PagingController<T, K> pagingController;
  final Widget Function(BuildContext, K, int) itemBuilder;

  final VisualizationType visualizationType;

  const PagingListGrid(
      {super.key,
      required this.visualizationType,
      required this.pagingController,
      required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    switch (visualizationType) {
      case VisualizationType.LIST:
        return PagedListView<T, K>(
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<K>(
            itemBuilder: itemBuilder,
            noItemsFoundIndicatorBuilder: (context) =>
                const NoRegisteredBookPlaceholder(),
          ),
        );
      case VisualizationType.GRID:
        return PagedGridView<T, K>(
          pagingController: pagingController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.5),
          builderDelegate: PagedChildBuilderDelegate<K>(
            itemBuilder: itemBuilder,
            noItemsFoundIndicatorBuilder: (context) =>
                const NoRegisteredBookPlaceholder(),
          ),
        );
    }
  }
}
