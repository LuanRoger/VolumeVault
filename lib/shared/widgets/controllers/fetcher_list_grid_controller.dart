part of '../fetcher_list_grid.dart';

class FetcherListGridController<T> extends ChangeNotifier {
  final _FetcherListGridControllerBridge<T> _bridge;

  FetcherListGridController(
      {List<T>? data,
      VisualizationType visualizationType = VisualizationType.LIST})
      : _bridge = _FetcherListGridControllerBridge(
            data = const [], visualizationType);

  List<T> get data => List.from(_bridge.data);
  set data(List<T> children) {
    _bridge.data = children;
    notifyListeners();
  }

  VisualizationType get visualizationType => _bridge.visualizationType;
  set visualizationType(VisualizationType visualizationType) {
    _bridge.visualizationType = visualizationType;
    notifyListeners();
  }

  void refresh() {
    _bridge.needToRefresh = true;
    notifyListeners();
  }
}

class _FetcherListGridControllerBridge<T> {
  List<T> data;
  VisualizationType visualizationType;
  bool needToRefresh = false;

  _FetcherListGridControllerBridge(this.data, this.visualizationType);
}
