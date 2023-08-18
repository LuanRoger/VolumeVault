import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import "package:volume_vault/l10n/l10n.dart";
import 'package:volume_vault/models/book_model.dart';
import "package:volume_vault/models/book_result_limiter.dart";
import 'package:volume_vault/models/book_sort_option.dart';
import "package:volume_vault/models/enums/book_format.dart";
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/pages/book_info_view/commands/book_info_viewer_command.dart';
import 'package:volume_vault/pages/home_page/sections/home_section/commands/home_section_desktop_command.dart';
import 'package:volume_vault/pages/home_page/sections/widgets/card_book_view_content.dart';
import 'package:volume_vault/providers/providers.dart';
import "package:volume_vault/services/models/book_stats.dart";
import 'package:volume_vault/services/models/get_user_book_request.dart';
import 'package:volume_vault/services/models/user_book_result.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/widgets/images/user_profile_image.dart';
import "package:volume_vault/shared/widgets/lists/pagination_list_grid.dart";
import 'package:volume_vault/shared/widgets/lists/pagination_sliver_list_grid.dart';
import 'package:volume_vault/shared/widgets/text_fields/search_text_field.dart';
import 'package:volume_vault/shared/widgets/widget_switcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeSectionDesktop extends HookConsumerWidget {
  final HomeSectionDesktopCommand _commands = HomeSectionDesktopCommand();
  final _bookInfoViewerCommand = const BookInfoViewerCommand();

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
    final tabBookFormatController = useTabController(initialLength: 10);

    final userInfo = ref.watch(userSessionAuthProvider);
    final visualizationTypeState = useState(VisualizationType.LIST);
    final resultLimiterState = useState<BookResultLimiter?>(null);
    final sortOptionState = useState(BookSortOption());
    final bookStatsState = useState<BookStats?>(null);

    useEffect(() {
      Future<void> bookFetcher(int pageKey) async {
        bookStatsState.value = await _commands.getUserBookStats(ref);
        final result = await _commands.fetchUserBooks(
          ref,
          GetUserBookRequest(
              page: pageKey,
              sortOptions: sortOptionState.value,
              resultLimiter: resultLimiterState.value),
        );
        if (result.books.isEmpty) {
          pagingController.appendLastPage(result.books);
          return;
        }
        pagingController.appendPage(result.books, pageKey + 1);
      }

      void onSearchTextChange() {
        refreshSearchResultKey.value = UniqueKey();
      }

      _commands.bookOnViwerState = bookOnViwer;
      pagingController.addPageRequestListener(bookFetcher);
      searchTextController.addListener(onSearchTextChange);

      return () {
        pagingController.removePageRequestListener(bookFetcher);
        searchTextController.removeListener(onSearchTextChange);
      };
    });

    return Scaffold(
      appBar: AppBar(
        title: WidgetSwitcher(
          first: Text(AppLocalizations.of(context)!.titleAppBarHomePage),
          second: userInfo != null
              ? Text(AppLocalizations.of(context)!
                  .helloUserAppBarHomePage(userInfo.name))
              : const SizedBox(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              _commands.showConfigurationsDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () => context.push(AppRoutes.aboutPageRoute),
          )
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
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
                          showClearButton: searchTextController.text.isNotEmpty,
                          height: 40,
                          trailing: [
                            IconButton(
                              onPressed: () async => _commands.showProfileCard(
                                  context,
                                  heightFactor: 0.8,
                                  widthFactor: 0.8),
                              icon: UserProfileImage(
                                letterStyle: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(fontSize: 12),
                                height: 40,
                                width: 40,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Flexible(
                        flex: 0,
                        child: IconButton(
                          onPressed: () async => pagingController.refresh(),
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
                              bookStatsState.value?.count ?? 0),
                          style: Theme.of(context).textTheme.bodyLarge),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!ResponsiveWrapper.of(context).isTablet)
                            IconButton(
                              onPressed: () {
                                visualizationTypeState.value =
                                    visualizationTypeState.value ==
                                            VisualizationType.LIST
                                        ? VisualizationType.GRID
                                        : VisualizationType.LIST;
                              },
                              icon: Icon(visualizationTypeState.value ==
                                      VisualizationType.LIST
                                  ? Icons.grid_view_rounded
                                  : Icons.view_list_rounded),
                            ),
                          IconButton(
                              onPressed: () async {
                                BookSortOption? newSortOptions = await _commands
                                    .showSortFilterDialog(context,
                                        currentOptions: sortOptionState.value,
                                        wrapped: true,
                                        full: ResponsiveWrapper.of(context)
                                            .isTablet);
                                if (newSortOptions == null) return;
                                sortOptionState.value = newSortOptions;

                                pagingController.refresh();
                              },
                              icon: const Icon(Icons.sort_rounded)),
                        ],
                      )
                    ],
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: TabBar(
                    controller: tabBookFormatController,
                    isScrollable: true,
                    onTap: (index) {
                      resultLimiterState.value = BookResultLimiter(
                          format:
                              index != 0 ? BookFormat.values[index - 1] : null);
                      pagingController.refresh();
                    },
                    tabs: [
                      Tab(
                          text: AppLocalizations.of(context)!
                              .allBooksFormatsTabOption),
                      Tab(
                        text: L10n.bookFormat(context,
                            format: BookFormat.hardcover),
                      ),
                      Tab(
                          text: L10n.bookFormat(context,
                              format: BookFormat.hardback)),
                      Tab(
                        text: L10n.bookFormat(context,
                            format: BookFormat.paperback),
                      ),
                      Tab(
                        text:
                            L10n.bookFormat(context, format: BookFormat.ebook),
                      ),
                      Tab(
                        text:
                            L10n.bookFormat(context, format: BookFormat.pocket),
                      ),
                      Tab(
                          text: L10n.bookFormat(context,
                              format: BookFormat.audioBook)),
                      Tab(
                        text:
                            L10n.bookFormat(context, format: BookFormat.spiral),
                      ),
                      Tab(
                          text:
                              L10n.bookFormat(context, format: BookFormat.hq)),
                      Tab(
                        text: L10n.bookFormat(context,
                            format: BookFormat.collectorsEdition),
                      ),
                    ],
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
                    child: Builder(
                      builder: (context) {
                        if (searchTextController.text.isEmpty) {
                          return PaginationListGrid<int, BookModel>(
                            pagingController: pagingController,
                            visualizationType: visualizationTypeState.value,
                            itemBuilder: (_, data, index) {
                              return _commands.buildBookView(context, ref,
                                  book: data,
                                  viewType: visualizationTypeState.value,
                                  onUpdate: pagingController.refresh,
                                  bookInfoViewerStrategy:
                                      _bookInfoViewerCommand,
                                  onSelect: (book) => _commands.onBookSelect(
                                      context, ref, book));
                            },
                          );
                        }
                        if (searchFuture.connectionState ==
                                ConnectionState.waiting ||
                            !searchFuture.hasData) {
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
                                final refresh = await context
                                    .push<bool>(
                                        AppRoutes.registerEditBookPageRoute,
                                        extra: [bookOnViwer.value!, true]);
                                if (refresh == null || !refresh) return;

                                pagingController.refresh();

                                if (bookOnViwer.value == null) return;
                                bookOnViwer.value = await _bookInfoViewerCommand
                                    .refreshBookInfo(
                                        context, ref, bookOnViwer.value!.id);
                              },
                              icon: const Icon(Icons.edit_rounded)),
                          if (bookOnViwer.value!.buyLink != null)
                            IconButton(
                                onPressed: () => _bookInfoViewerCommand
                                    .launchBuyPage(bookOnViwer.value!.buyLink!),
                                icon: const Icon(Icons.shopping_cart_rounded)),
                          IconButton(
                            onPressed: () async {
                              bool delete = await _bookInfoViewerCommand
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
                            await _bookInfoViewerCommand.refreshBookInfo(
                                context, ref, bookOnViwer.value!.id);
                        if (newInfoBook == null) return;

                        bookOnViwer.value = newInfoBook;
                      },
                      onCardPressed: (cardLabel, context) async {
                        searchTextController.text = cardLabel;
                      },
                    ),
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
