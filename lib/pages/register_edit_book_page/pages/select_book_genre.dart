import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SelectBookGenre extends HookConsumerWidget {
  final Set<String>? alreadyAddedGenres;

  const SelectBookGenre({super.key, this.alreadyAddedGenres});

  Future<Set<String>> _fetchBookGenres(WidgetRef ref) async {
    return const {
      "Ação",
      "Aventura",
      "Comédia",
      "Drama",
      "Fantasia",
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGenres = useState<Set<String>>(const {});

    final fetchGenresMemoize = useMemoized(() => _fetchBookGenres);
    final fetchFuture = useFuture(fetchGenresMemoize(ref));

    return Scaffold(
        appBar: AppBar(
          title: const Text("Selecione generos"),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context, selectedGenres.value),
              icon: const Icon(Icons.check_rounded),
            )
          ],
        ),
        body: (() {
          if (fetchFuture.connectionState == ConnectionState.waiting &&
              !fetchFuture.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (fetchFuture.hasError || fetchFuture.data!.isEmpty) {
            return Center(
                child: Text(
              "Não há generos disponiveis.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ));
          }
          return ListView.separated(
            itemCount: fetchFuture.data!.length,
            itemBuilder: (context, index) {
              final String genre = fetchFuture.data!.elementAt(index);
              return CheckboxListTile(
                  title: Text(genre),
                  value: selectedGenres.value.contains(genre) ||
                      (alreadyAddedGenres?.contains(genre) ?? false),
                  enabled: !(alreadyAddedGenres?.contains(genre) ?? true),
                  onChanged: (newValue) {
                    if (newValue == true) {
                      selectedGenres.value = {...selectedGenres.value, genre};
                    } else {
                      final Set<String> removeGenreSet =
                          Set.from(selectedGenres.value)..remove(genre);
                      selectedGenres.value = removeGenreSet;
                    }
                  });
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        }()));
  }
}
