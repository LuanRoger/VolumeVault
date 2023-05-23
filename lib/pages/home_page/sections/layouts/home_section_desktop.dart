import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/book_sort_option.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/pages/book_info_view/commands/book_info_viewer_command.dart';
import 'package:volume_vault/pages/home_page/sections/commands/home_section_desktop_command.dart';
import 'package:volume_vault/pages/home_page/sections/widgets/card_book_view_content.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/get_user_book_request.dart';
import 'package:volume_vault/services/models/user_book_result.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/widgets/lists/pagination_list_grid.dart';
import 'package:volume_vault/shared/widgets/text_fields/search_text_field.dart';
import 'package:volume_vault/shared/widgets/widget_switcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeSectionDesktop extends HookConsumerWidget {
  final HomeSectionDesktopCommand _commands = HomeSectionDesktopCommand();
  final _bookCommnads = const BookInfoViewerCommand();

  final PagingController<int, BookModel> pagingController;

  HomeSectionDesktop(this.pagingController, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookOnViwer = useState<BookModel?>(null);
    final bookTaskLoadingState = useState(false);

    final searchTextController = useTextEditingController();
    final refreshSearchResultKey = useState(UniqueKey());
    final searchMemoize = useMemoized(
        () => _commands.search(searchTextController.text, ref),
        [refreshSearchResultKey.value]);
    final searchFuture = useFuture(searchMemoize);

    final userInfo = ref.watch(userSessionAuthProvider);
    final visualizationTypeState = useState(VisualizationType.LIST);
    final sortOptionState = useState(BookSortOption());

    final refreshKeyState = useState(UniqueKey());
    final bookStatsMemoize = useMemoized(
      () => _commands.getUserBookStats(ref),
      [refreshKeyState.value],
    );
    final bookStatsFuture = useFuture(bookStatsMemoize);

    useEffect(() {
      bookFetcher(pageKey) async {
        UserBookResult result = await _commands.fetchUserBooks(
          ref,
          GetUserBookRequest(page: pageKey),
          sortOptions: sortOptionState.value,
        );
        if (result.books.isEmpty) {
          pagingController.appendLastPage(result.books);
          return;
        }
        pagingController.appendPage(result.books, pageKey + 1);
      }

      onSearchTextChange() {
        refreshSearchResultKey.value = UniqueKey();
      }

      pagingController.addPageRequestListener(bookFetcher);
      searchTextController.addListener(onSearchTextChange);

      return () {
        pagingController.removePageRequestListener(bookFetcher);
        searchTextController.removeListener(onSearchTextChange);
      };
    }, [refreshKeyState.value]);
    useEffect(() {
      _commands.bookOnViwerState = bookOnViwer;

      return () {};
    });

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
                    AppLocalizations.of(context)!.appName,
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: Text(AppLocalizations.of(context)!.signoutButtonHomePage),
              onTap: () async => await _commands.showLogoutDialog(context, ref),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: WidgetSwitcher(
          first: Text(AppLocalizations.of(context)!.titleAppBarHomePage),
          second: userInfo != null
              ? Text(AppLocalizations.of(context)!
                  .helloUserAppBarHomePage(userInfo.name))
              : const SizedBox(),
        ),
        actions: [
          if (!ResponsiveWrapper.of(context).isTablet)
            IconButton(
              onPressed: () {
                visualizationTypeState.value =
                    visualizationTypeState.value == VisualizationType.LIST
                        ? VisualizationType.GRID
                        : VisualizationType.LIST;
              },
              icon: Icon(visualizationTypeState.value == VisualizationType.LIST
                  ? Icons.grid_view_rounded
                  : Icons.view_list_rounded),
            ),
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Flexible(
                  flex: 0,
                  child: Row(
                    children: [
                      Flexible(
                        child: SearchTextField(
                            controller: searchTextController,
                            label: AppLocalizations.of(context)!
                                .searchBookTextFieldHint,
                            showClearButton:
                                searchTextController.text.isNotEmpty,
                            height: 40),
                      ),
                      const SizedBox(width: 8.0),
                      Flexible(
                        flex: 0,
                        child: IconButton(
                          onPressed: () {
                            pagingController.refresh();
                            refreshKeyState.value = UniqueKey();
                          },
                          icon: const Icon(Icons.refresh_rounded),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          AppLocalizations.of(context)!.bookCountStatsHomePage(
                              bookStatsFuture.hasData
                                  ? bookStatsFuture.data!.count
                                  : 0),
                          style: Theme.of(context).textTheme.bodyLarge),
                      IconButton(
                          onPressed: () async {
                            BookSortOption? newSortOptions =
                                await _commands.showSortFilterDialog(context,
                                    currentOptions: sortOptionState.value,
                                    wrapped: true);
                            if (newSortOptions == null) return;
                            sortOptionState.value = newSortOptions;

                            pagingController.refresh();
                          },
                          icon: const Icon(Icons.sort_rounded))
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: PageTransitionSwitcher(
                    transitionBuilder: (child, animation, secondaryAnimation) =>
                        SharedAxisTransition(
                            animation: animation,
                            secondaryAnimation: secondaryAnimation,
                            transitionType: SharedAxisTransitionType.horizontal,
                            child: child),
                    child: Builder(
                      builder: (context) {
                        if (searchTextController.text.isEmpty) {
                          return PaginationListGrid<int, BookModel>(
                            pagingController: pagingController,
                            visualizationType: visualizationTypeState.value,
                            itemBuilder: (_, data, index) {
                              return _commands.buildBookView(context,
                                  book: data,
                                  viewType: visualizationTypeState.value,
                                  onUpdate: pagingController.refresh,
                                  onSelect: (book) =>
                                      _commands.onBookSelect(context, book));
                            },
                          );
                        }
                        if (searchFuture.connectionState ==
                            ConnectionState.waiting || !searchFuture.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return ListView(
                          key: ValueKey(searchTextController.text),
                          children: _commands.buildSearhResultTiles(
                              searchFuture.data!, context, ref),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                if (bookOnViwer.value != null)
                  Flexible(
                    flex: 0,
                    child: Card(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () async {
                                final bool? refresh =
                                    await Navigator.pushNamed<bool>(context,
                                        AppRoutes.registerEditBookPageRoute,
                                        arguments: [bookOnViwer.value!]);
                                if (refresh == null || !refresh) return;

                                pagingController.refresh();

                                if (bookOnViwer.value == null) return;
                                bookOnViwer.value =
                                    await _bookCommnads.refreshBookInfo(
                                        context, ref, bookOnViwer.value!.id);
                              },
                              icon: const Icon(Icons.edit_rounded)),
                          if (bookOnViwer.value!.buyLink != null)
                            IconButton(
                                onPressed: () => _bookCommnads
                                    .launchBuyPage(bookOnViwer.value!.buyLink!),
                                icon: const Icon(Icons.shopping_cart_rounded)),
                          IconButton(
                            onPressed: () async {
                              bool delete = await _bookCommnads
                                  .showDeleteBookDialog(context);
                              if (!delete) return;
                              bookTaskLoadingState.value = true;

                              final controller =
                                  await ref.read(bookControllerProvider.future);
                              final result = await controller
                                  .deleteBook(bookOnViwer.value!.id);
                              if (!result) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Erro ao deletar livro"),
                                  ),
                                );
                              } else {
                                bookOnViwer.value = null;
                                pagingController.refresh();
                              }
                            },
                            icon: const Icon(Icons.delete_rounded),
                          ),
                        ],
                      ),
                    ),
                  ),
                Flexible(
                  flex: 1,
                  child: Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: CardBookViewContent(
                        book: bookOnViwer.value,
                        onRefresh: () async {
                          final BookModel? newInfoBook =
                              await _bookCommnads.refreshBookInfo(
                                  context, ref, bookOnViwer.value!.id);
                          if (newInfoBook == null) return;

                          bookOnViwer.value = newInfoBook;
                        }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
