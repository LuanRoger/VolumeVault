import "package:flutter/material.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:volume_vault/models/enums/visualization_type.dart";

abstract class PaginationListGridBase<T, K> extends StatelessWidget {
  final PagingController<T, K> pagingController;
  final Widget Function(BuildContext, K, int) itemBuilder;
  final VisualizationType visualizationType;

  const PaginationListGridBase(
      {required this.visualizationType,
      required this.pagingController,
      required this.itemBuilder,
      super.key});
}
