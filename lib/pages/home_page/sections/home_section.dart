import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/book_search_result.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/pages/register_edit_book_page/register_edit_book_page.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/get_user_book_request.dart';
import 'package:volume_vault/services/models/user_book_result.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/widgets/book_info_scrollable_tiles/book_info_card.dart';
import 'package:volume_vault/shared/widgets/book_info_scrollable_tiles/book_info_grid_card.dart';
import 'package:volume_vault/shared/widgets/book_info_scrollable_tiles/book_info_list_card.dart';
import 'package:volume_vault/shared/widgets/book_search_result_tile.dart';
import 'package:volume_vault/shared/widgets/fetcher_list_grid.dart';
import 'package:volume_vault/shared/widgets/placeholders/no_registered_book_placeholder.dart';
import 'package:volume_vault/shared/widgets/search_floating_card.dart';

class HomeSection extends HookConsumerWidget {
  VisualizationType? viewType;

  HomeSection({super.key, this.viewType});

  void _onCardPress(BuildContext context, BookModel bookModel,
      {void Function()? onUpdate}) {
    Navigator.pushNamed<bool>(context, AppRoutes.bookInfoViewerPageRoute,
        arguments: [bookModel]).then((value) {
      if (value == null || onUpdate == null) return;

      onUpdate.call();
    });
  }

  Future<UserBookResult> _fetchUserBooks(
      WidgetRef ref, GetUserBookRequest getUserBookRequest) async {
    final bookService = await ref.read(bookServiceProvider.future);
    if (bookService == null) return UserBookResult.empty();

    UserBookResult userBookResult =
        await bookService.getUserBook(getUserBookRequest);
    return userBookResult;
  }

  Future<List<BookSearchResult>> _search(String query, WidgetRef ref) async {
    final bookService = await ref.read(bookServiceProvider.future);
    if (bookService == null) return List.empty();

    List<BookSearchResult> searchResult = await bookService.searchBook(query);
    return searchResult;
  }

  List<BookInfoCard> _buildBookView(BuildContext context,
      {required List<BookModel> books,
      void Function()? onUpdate,
      VisualizationType viewType = VisualizationType.LIST}) {
    switch (viewType) {
      case VisualizationType.LIST:
        return [
          for (final book in books)
            BookInfoListCard(
              book,
              onPressed: () => _onCardPress(context, book, onUpdate: onUpdate),
            ),
        ];
      case VisualizationType.GRID:
        return [
          for (final book in books)
            BookInfoGridCard(
              book,
              onPressed: () => _onCardPress(context, book, onUpdate: onUpdate),
            ),
        ];
    }
  }

  Future _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    bool exit = false;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text("Sair da conta?"),
          content: const Text("Deseja realmente sair da conta?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                exit = true;
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.loginPageRoute, (route) => false);
              },
              child: const Text("Sair"),
            ),
          ]),
    );

    if (exit) {
      ref.read(userSessionNotifierProvider.notifier).clear();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoProvider);

    final fetchLastPageKey = useState(UniqueKey());
    final booksFetcherRequest = useState(GetUserBookRequest(page: 1));
    final userBooks = useState(List<BookModel>.empty());
    final fetchMemoizer = useMemoized(
        () => _fetchUserBooks(ref, booksFetcherRequest.value),
        [booksFetcherRequest.value, fetchLastPageKey.value]);
    final fetchFuture = useFuture(fetchMemoizer, preserveState: false);

    final lastDataPage = useState(1);
    final visualizationType =
        useState<VisualizationType>(viewType ?? VisualizationType.LIST);

    useEffect(() {
      if (fetchFuture.hasData &&
          fetchFuture.connectionState == ConnectionState.done &&
          fetchFuture.data!.books.isNotEmpty &&
          userBooks.value.length != fetchFuture.data!.books.length) {
        final List<BookModel> newBooks = List.from(fetchFuture.data!.books);
        final List<BookModel> booksFromList = List.from(userBooks.value);
        List<BookModel> updatedBooks;
        if (newBooks.length > booksFromList.length) {
          final leftBooks =
              newBooks.sublist(booksFromList.length, newBooks.length);
          updatedBooks = [...booksFromList, ...leftBooks];
        } else {
          int startRange =
              (booksFromList.length ~/ booksFetcherRequest.value.limitPerPage) *
                  booksFetcherRequest.value.limitPerPage;
          booksFromList.removeRange(startRange, booksFromList.length);
          updatedBooks = [...booksFromList, ...newBooks];
        }

        userBooks.value = updatedBooks;
        lastDataPage.value = booksFetcherRequest.value.page;
      }

      if (fetchFuture.hasData &&
          fetchFuture.data!.books.isEmpty &&
          booksFetcherRequest.value.page > 1) {
        booksFetcherRequest.value = booksFetcherRequest.value
            .copyWith(page: booksFetcherRequest.value.page - 1);
        lastDataPage.value = booksFetcherRequest.value.page;
      }
      return () {};
    }, [fetchFuture.connectionState, fetchLastPageKey.value]);

    final searchTextController = useTextEditingController();

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Volume Vault",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  userInfo.maybeWhen(
                      data: (data) {
                        if (data == null) return const SizedBox();

                        return Text("Olá, ${data.username}");
                      },
                      orElse: () => const SizedBox())
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text("Sair da conta"),
              onTap: () async {
                await _showLogoutDialog(context, ref);
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Início"),
        actions: [
          IconButton(
              onPressed: () async {
                SearchFloatingCard searchFloatingCard = SearchFloatingCard(
                    controller: searchTextController,
                    search: (query, dialogContext) async {
                      return await _search(query, ref).then((searchResult) => [
                            for (final bookResult in searchResult)
                              BookSearchResultTile(
                                bookResult,
                                onTap: () async {
                                  Navigator.pop(dialogContext);
                                  final bookService = await ref
                                      .read(bookServiceProvider.future);
                                  final BookModel? book = await bookService
                                      ?.getUserBookById(bookResult.id);
                                  if (bookService == null || book == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Este livro não está disponível"),
                                      ),
                                    );
                                    return;
                                  }
                                  _onCardPress(context, book);
                                },
                              )
                          ]);
                    });
                await searchFloatingCard.show(context);
              },
              icon: const Icon(Icons.search_rounded)),
          IconButton(
            onPressed: () {
              visualizationType.value =
                  visualizationType.value == VisualizationType.LIST
                      ? VisualizationType.GRID
                      : VisualizationType.LIST;
            },
            icon: Icon(visualizationType.value == VisualizationType.LIST
                ? Icons.grid_view_rounded
                : Icons.view_list_rounded),
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.configurationsPageRoute),
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          userBooks.value = List.empty();
          booksFetcherRequest.value = booksFetcherRequest.value.copyWith(
            page: 1,
          );
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: PageTransitionSwitcher(
          transitionBuilder: (child, animation, secondaryAnimation) =>
              FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child),
          child: userBooks.value.isEmpty
              ? const Center(child: NoRegisteredBookPlaceholder())
              : FetcherListGrid(
                  key: ValueKey(visualizationType.value),
                  visualizationType: visualizationType.value,
                  reachScrollBottom: () {
                    if (booksFetcherRequest.value.page > lastDataPage.value) {
                      return;
                    }
                    booksFetcherRequest.value =
                        booksFetcherRequest.value.copyWith(
                      page: booksFetcherRequest.value.page + 1,
                    );
                  },
                  children: _buildBookView(
                    context,
                    books: userBooks.value,
                    viewType: visualizationType.value,
                    onUpdate: () => fetchLastPageKey.value = UniqueKey(),
                  ),
                ),
        ),
      ),
      floatingActionButton: OpenContainer(
        clipBehavior: Clip.none,
        openColor: Theme.of(context).colorScheme.background,
        closedColor: Theme.of(context).colorScheme.background,
        onClosed: (_) => fetchLastPageKey.value = UniqueKey(),
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        closedBuilder: (_, open) => FloatingActionButton(
            onPressed: open, child: const Icon(Icons.add_rounded)),
        openBuilder: (_, __) => RegisterEditBookPage(),
      ),
    );
  }
}
