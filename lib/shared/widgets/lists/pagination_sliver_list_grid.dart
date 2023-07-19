import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import "package:volume_vault/shared/widgets/lists/pagination_list_grid_base.dart";
import 'package:volume_vault/shared/widgets/placeholders/no_registered_book_placeholder.dart';

class PaginationSliverListGrid<T, K> extends PaginationListGridBase<T, K> {
  const PaginationSliverListGrid(
      {required super.visualizationType,
      required super.pagingController,
      required super.itemBuilder,
      super.key});

  @override
  Widget build(BuildContext context) {
    switch (visualizationType) {
      case VisualizationType.LIST:
        return PagedSliverList<T, K>(
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<K>(
            itemBuilder: itemBuilder,
            noItemsFoundIndicatorBuilder: (context) =>
                const NoRegisteredBookPlaceholder(),
          ),
        );
      case VisualizationType.GRID:
        return PagedSliverGrid<T, K>(
          pagingController: pagingController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.46),
          builderDelegate: PagedChildBuilderDelegate<K>(
            itemBuilder: itemBuilder,
            noItemsFoundIndicatorBuilder: (context) =>
                const NoRegisteredBookPlaceholder(),
          ),
        );
    }
  }
}
