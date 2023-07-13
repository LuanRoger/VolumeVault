import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:volume_vault/models/books_genres_model.dart";
import "package:volume_vault/providers/providers.dart";

class SelectBookGenre extends HookConsumerWidget {
  final Set<String>? allreadyAddedGenres;

  const SelectBookGenre({super.key, this.allreadyAddedGenres});

  Future<BooksGenresModel?> _fetchBookGenres(WidgetRef ref) async {
    final bookContoller = await ref.read(bookControllerProvider.future);
    final genres = await bookContoller.getBooksGenres();

    return genres;
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
              onPressed: () => context.pop(selectedGenres.value),
              icon: const Icon(Icons.check_rounded),
            )
          ],
        ),
        body: () {
          if (fetchFuture.connectionState == ConnectionState.waiting &&
              !fetchFuture.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (fetchFuture.hasError || !fetchFuture.hasData) {
            return Center(
                child: Text(
              "Não há generos disponiveis.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ));
          }
          return ListView.separated(
            itemCount: fetchFuture.data!.count,
            itemBuilder: (context, index) {
              final genre = fetchFuture.data!.genres.elementAt(index);
              return CheckboxListTile(
                  title: Text(genre),
                  value: selectedGenres.value.contains(genre) ||
                      (allreadyAddedGenres?.contains(genre) ?? false),
                  enabled: !(allreadyAddedGenres?.contains(genre) ?? true),
                  onChanged: (newValue) {
                    if (newValue == null) return;
                    if (newValue) {
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
        }());
  }
}
