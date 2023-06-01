import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:volume_vault/models/book_search_result.dart';
import 'package:volume_vault/shared/widgets/chip/search_filter_chip_choice.dart';

class SearchFloatingCard {
  final TextEditingController controller;
  final Future<BookSearchResult?> Function(String query) search;
  final List<Widget> Function(BookSearchResult, BuildContext)
      searchResultBuilder;
  final Size? size;

  SearchFloatingCard(
      {required this.controller,
      required this.search,
      required this.searchResultBuilder,
      this.size});

  Future<void> show(BuildContext context) {
    final Size dialogSize = size ?? MediaQuery.of(context).size;

    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pageBuilder: (context, animation, secondaryAnimation) {
          return Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: dialogSize.width * 0.8,
              height: dialogSize.height * 0.9,
              child: _SeachCard(
                  controller: controller,
                  search: search,
                  searchResultBuilder: searchResultBuilder),
            ),
          );
        });
  }
}

class _SeachCard extends HookWidget {
  final TextEditingController controller;
  final List<Widget> Function(BookSearchResult, BuildContext)
      searchResultBuilder;
  final Future<BookSearchResult?> Function(String query) search;

  const _SeachCard(
      {required this.controller,
      required this.search,
      required this.searchResultBuilder});

  @override
  Widget build(BuildContext context) {
    final refreshSearchResultKey = useState(UniqueKey());
    final searchMemoize = useMemoized(
        () => search(controller.text), [refreshSearchResultKey.value]);
    final searchFuture = useFuture(searchMemoize);
    useEffect(() {
      onChange() {
        refreshSearchResultKey.value = UniqueKey();
      }

      controller.addListener(onChange);

      return () => controller.removeListener(onChange);
    });

    return Card(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 0,
                child: TextField(
                  controller: controller,
                  maxLines: 1,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: IconButton(
                        onPressed: () => controller.clear(),
                        icon: const Icon(Icons.backspace_rounded),
                      ),
                      suffixText:
                          "${searchFuture.data?.searchElapsedTime.inMilliseconds.toString() ?? "0"}ms",
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none),
                      filled: true,
                      isDense: true,
                      contentPadding: const EdgeInsets.all(8.0)),
                ),
              ),
              const Flexible(flex: 0, child: SearchFilterChipChoice()),
              Expanded(
                  child: PageTransitionSwitcher(
                transitionBuilder: (child, animation, secondaryAnimation) =>
                    SharedAxisTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.horizontal,
                        child: child),
                child: searchFuture.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        padding: EdgeInsets.zero,
                        children: searchFuture.data != null
                            ? searchResultBuilder(searchFuture.data!, context)
                            : List.empty(),
                      ),
              )),
            ],
          ),
        ));
  }
}
