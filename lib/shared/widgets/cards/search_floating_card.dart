// ignore_for_file: lines_longer_than_80_chars

import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:volume_vault/models/book_search_result.dart";
import "package:volume_vault/shared/widgets/chip/search_filter_chip_choice.dart";

class SearchFloatingCard {
  final String initialSearch;
  final Future<BookSearchResult?> Function(String query) search;
  final List<Widget> Function(BookSearchResult, BuildContext)
      searchResultBuilder;
  final Size? size;

  SearchFloatingCard({
    required this.search,
    required this.searchResultBuilder,
    this.initialSearch = "",
    this.size,
  });

  Future<void> show(BuildContext context) {
    final dialogSize = size ?? MediaQuery.of(context).size;

    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pageBuilder: (context, animation, secondaryAnimation) {
          return Align(
            child: SizedBox(
              width: dialogSize.width * 0.8,
              height: dialogSize.height * 0.9,
              child: _SeachCard(
                  initialSearch: initialSearch,
                  search: search,
                  searchResultBuilder: searchResultBuilder),
            ),
          );
        });
  }
}

class _SeachCard extends HookWidget {
  final String initialSearch;
  final List<Widget> Function(BookSearchResult, BuildContext)
      searchResultBuilder;
  final Future<BookSearchResult?> Function(String query) search;

  const _SeachCard(
      {required this.initialSearch,
      required this.search,
      required this.searchResultBuilder});

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController(text: initialSearch);
    final refreshSearchResultKey = useState(UniqueKey());
    final searchMemoize = useMemoized(
        () => search(searchController.text), [refreshSearchResultKey.value]);
    final searchFuture = useFuture(searchMemoize);
    useEffect(() {
      void onChange() {
        refreshSearchResultKey.value = UniqueKey();
      }

      searchController.addListener(onChange);

      return () => searchController.removeListener(onChange);
    });

    return Card(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 0,
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: IconButton(
                        onPressed: searchController.clear,
                        icon: const Icon(Icons.backspace_rounded),
                      ),
                      suffixText:
                          "${searchFuture.data?.searchElapsedTime.inMilliseconds.toString() ?? "0"}ms",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      isDense: true,
                      contentPadding: const EdgeInsets.all(8)),
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
