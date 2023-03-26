import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

PagingController<T, K> usePagingController<T, K>({required T firstPageKey}) =>
    use(_PagingControllerHook(firstPageKey));

class _PagingControllerHook<T, K> extends Hook<PagingController<T, K>> {
  final T firstPageKey;

  const _PagingControllerHook(this.firstPageKey);

  @override
  HookState<PagingController<T, K>, Hook<PagingController<T, K>>>
      createState() => _PagingControllerHookState<T, K>();
}

class _PagingControllerHookState<T, K>
    extends HookState<PagingController<T, K>, _PagingControllerHook<T, K>> {
  late final PagingController<T, K> controller;

  @override
  void initHook() {
    super.initHook();
    controller = PagingController<T, K>(firstPageKey: hook.firstPageKey);
  }

  @override
  PagingController<T, K> build(BuildContext context) => controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
