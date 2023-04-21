import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SearchResultList extends HookWidget {
  final Widget noData;
  final Future<List<Widget>> Function(String, BuildContext) search;
  final TextEditingController textController;

  const SearchResultList(
      {super.key,
      this.noData = const SizedBox(),
      required this.search,
      required this.textController});

  @override
  Widget build(BuildContext context) {
    final searchQueryChangeKey = useState(UniqueKey());
    final searchMemoize = useMemoized(
        () => search(textController.text, context),
        [searchQueryChangeKey.value]);
    final searchFuture = useFuture(searchMemoize,
        initialData: List<Widget>.empty(), preserveState: false);

    useEffect(() {
      textListener() {
        searchQueryChangeKey.value = UniqueKey();
      }

      textController.addListener(textListener);

      return () => textController.removeListener(textListener);
    });

    return searchFuture.hasData
        ? ListView(
            padding: EdgeInsets.zero,
            children: searchFuture.data!,
          )
        : noData;
  }
}
