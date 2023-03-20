import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';

part 'controllers/fetcher_list_grid_controller.dart';

class FetcherListGrid<T> extends HookConsumerWidget {
  FetcherListGridController<T> controller;
  final void Function(int page)? reachScrollBottom;
  final Future<List<T>> Function(int page) fetcher;
  final List<Widget> Function(List<T>) builder;
  bool isLoading;
  int limitUntilFetch;

  FetcherListGrid(
      {super.key,
      required this.controller,
      required this.builder,
      required this.fetcher,
      this.reachScrollBottom,
      this.isLoading = false,
      this.limitUntilFetch = 10});

  Widget _buildBookView(List<Widget> children,
      {ScrollController? scrollController}) {
    switch (controller.visualizationType) {
      case VisualizationType.LIST:
        return ListView(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          children: children,
        );
      case VisualizationType.GRID:
        return GridView(
          controller: scrollController,
          scrollDirection: Axis.vertical,
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
    final dataState = useState<List<T>>(List.empty());
    final lastDataPage = useState(1);
    final fetchMemoizer = useMemoized(() => fetcher(lastDataPage.value));
    final fetchFuture = useFuture(fetchMemoizer, preserveState: false);

    useListenable(controller);

    useEffect(
      () {
        scrollListener() {
          if (scrollController.position.maxScrollExtent !=
              scrollController.offset) return;
          reachScrollBottom?.call(lastDataPage.value);
        }

        scrollController.addListener(scrollListener);

        return () {
          scrollController.removeListener(scrollListener);
        };
      },
    );

    useEffect(() {
      if (fetchFuture.hasData &&
          fetchFuture.connectionState == ConnectionState.done &&
          fetchFuture.data!.isNotEmpty &&
          dataState.value.length != fetchFuture.data!.length) {
        final List<T> newData = List.from(fetchFuture.data!);
        final List<T> dataFromInterable = List.from(dataState.value);
        List<T> updatedBooks;
        if (newData.length > dataFromInterable.length) {
          final leftData =
              newData.sublist(dataFromInterable.length, newData.length);
          updatedBooks = [...dataFromInterable, ...leftData];
        } else {
          int startRange =
              (dataFromInterable.length ~/ limitUntilFetch) * limitUntilFetch;
          dataFromInterable.removeRange(startRange, dataFromInterable.length);
          updatedBooks = [...dataFromInterable, ...newData];
        }

        dataState.value = updatedBooks;
        controller._bridge.data = updatedBooks;
        lastDataPage.value++;
      }

      if (fetchFuture.hasData &&
          fetchFuture.data!.isEmpty &&
          lastDataPage.value > 1) {
        lastDataPage.value = lastDataPage.value--;
      }
      return () {};
    }, [fetchFuture.connectionState]);

    return _buildBookView(builder(dataState.value),
        scrollController: scrollController);
  }
}
