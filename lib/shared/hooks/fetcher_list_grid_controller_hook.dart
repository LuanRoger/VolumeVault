import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/shared/widgets/fetcher_list_grid.dart';

FetcherListGridController<T> useFetcherListGridController<T>() =>
    use(_FetcherListGridControllerHook<T>());

class _FetcherListGridControllerHook<T>
    extends Hook<FetcherListGridController<T>> {
  final List<T>? data;
  final VisualizationType visualizationType;

  const _FetcherListGridControllerHook(
      {this.data,
      this.visualizationType = VisualizationType.LIST});

  @override
  HookState<FetcherListGridController<T>, Hook<FetcherListGridController<T>>>
      createState() => _FetcherListGridControllerHookState<T>();
}

class _FetcherListGridControllerHookState<T> extends HookState<
    FetcherListGridController<T>, _FetcherListGridControllerHook<T>> {
  late final FetcherListGridController<T> controller;

  @override
  void initHook() {
    super.initHook();
    controller = FetcherListGridController();
  }

  @override
  FetcherListGridController<T> build(BuildContext context) => controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
