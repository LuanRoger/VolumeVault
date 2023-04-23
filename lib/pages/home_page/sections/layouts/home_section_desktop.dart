import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:realm/realm.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/pages/book_info_view/book_info_viewer_page.dart';
import 'package:volume_vault/pages/book_info_view/commands/book_info_viewer_command.dart';
import 'package:volume_vault/pages/home_page/sections/commands/home_section_desktop_command.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/get_user_book_request.dart';
import 'package:volume_vault/services/models/user_book_result.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/widgets/lists/pagination_list_grid.dart';
import 'package:volume_vault/shared/widgets/placeholders/no_book_selected_placeholder.dart';
import 'package:volume_vault/shared/widgets/lists/search_result_list.dart';
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
    useListenable(searchTextController);
    final userInfo = ref.watch(userInfoProvider);
    final visualizationTypeState = useState(VisualizationType.LIST);

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
        );
        if (result.books.isEmpty) {
          pagingController.appendLastPage(result.books);
          return;
        }
        pagingController.appendPage(result.books, pageKey + 1);
      }

      pagingController.addPageRequestListener(bookFetcher);

      return () => pagingController.removePageRequestListener(bookFetcher);
    });
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
          second: userInfo.maybeWhen(
              data: (data) {
                if (data == null) return const SizedBox();

                return Text(AppLocalizations.of(context)!
                    .helloUserAppBarHomePage(data.username));
              },
              loading: () => Text(
                  AppLocalizations.of(context)!.wellcomeBackAppBarHomePage),
              orElse: () => const SizedBox()),
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
                          "${bookStatsFuture.hasData ? bookStatsFuture.data!.count : "-"} livros",
                          style: Theme.of(context).textTheme.bodyLarge),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.sort_rounded))
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: PageTransitionSwitcher(
                      transitionBuilder:
                          (child, animation, secondaryAnimation) =>
                              SharedAxisTransition(
                                  animation: animation,
                                  secondaryAnimation: secondaryAnimation,
                                  transitionType:
                                      SharedAxisTransitionType.horizontal,
                                  child: child),
                      child: searchTextController.text.isEmpty
                          ? PaginationListGrid<int, BookModel>(
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
                            )
                          : SearchResultList(
                              key: ValueKey(searchTextController.text),
                              textController: searchTextController,
                              search: (query, context) async => await _commands
                                  .buildSearhResultTiles(query, context, ref)),
                    )),
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
                    child: _CardBookViewContent(
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

class _CardBookViewContent extends ConsumerWidget {
  final BookModel? book;
  final Future<void> Function() onRefresh;

  const _CardBookViewContent({required this.book, required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: AnimatedSize(
          alignment: Alignment.topCenter,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutQuart,
          child: SizedBox(
            width: double.infinity,
            child: book != null
                ? BookInfoViwerBodyPage(
                    book!,
                    onRefresh: onRefresh,
                  )
                : const NoBookSelectedPlaceholder(),
          )),
    );
  }
}
