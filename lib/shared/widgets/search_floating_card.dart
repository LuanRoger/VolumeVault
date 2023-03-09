import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchFloatingCard {
  final TextEditingController controller;
  final Future<List<Widget>> Function(String, BuildContext) search;
  final Size? size;

  SearchFloatingCard(
      {required this.controller,
      required this.search,
      this.size});

  Future<void> show(BuildContext context) {
    final Size dialogSize = size ?? MediaQuery.of(context).size;

    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pageBuilder: (context, animation, secondaryAnimation) {
          return Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: dialogSize.width * 0.8,
              height: dialogSize.height * 0.9,
              child: _SeachCard(
                  controller: controller,
                  search: search),
            ),
          );
        });
  }
}

class _SeachCard extends HookConsumerWidget {
  final TextEditingController controller;
  final Future<List<Widget>> Function(String, BuildContext) search;

  const _SeachCard(
      {required this.controller, required this.search});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQueryChangeKey = useState(UniqueKey());
    final searchMemoize = useMemoized(
        () => search(controller.text, context), [searchQueryChangeKey.value]);
    final searchFuture = useFuture(searchMemoize,
        initialData: List<Widget>.empty(), preserveState: false);

    useEffect(() {
      textListener() {
        searchQueryChangeKey.value = UniqueKey();
      }

      controller.addListener(textListener);

      return () => controller.removeListener(textListener);
    });

    return Card(
        clipBehavior: Clip.hardEdge,
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
                      icon: const Icon(Icons.clear),
                    ),
                    border: const OutlineInputBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                        borderSide: BorderSide.none),
                    filled: true,
                    isDense: true,
                    contentPadding: const EdgeInsets.all(8.0)),
              ),
            ),
            Expanded(
              child: PageTransitionSwitcher(
                  transitionBuilder: (child, animation, secondaryAnimation) =>
                      SharedAxisTransition(
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.horizontal,
                          child: child),
                  child: searchFuture.hasData
                      ? ListView(
                          key: UniqueKey(),
                          children: searchFuture.data!,
                        )
                      : const SizedBox()),
            ),
          ],
        ));
  }
}
