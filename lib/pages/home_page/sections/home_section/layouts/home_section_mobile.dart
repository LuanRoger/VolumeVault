import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:volume_vault/l10n/l10n.dart";
import 'package:volume_vault/models/book_model.dart';
import "package:volume_vault/models/book_result_limiter.dart";
import 'package:volume_vault/models/book_sort_option.dart';
import "package:volume_vault/models/enums/book_format.dart";
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/pages/book_info_view/commands/book_info_viewer_command.dart';
import 'package:volume_vault/pages/home_page/sections/home_section/commands/home_section_mobile_command.dart';
import 'package:volume_vault/pages/register_edit_book_page/register_edit_book_page.dart';
import 'package:volume_vault/providers/providers.dart';
import "package:volume_vault/services/models/book_stats.dart";
import 'package:volume_vault/services/models/get_user_book_request.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/widgets/images/user_profile_image.dart';
import 'package:volume_vault/shared/widgets/lists/pagination_sliver_list_grid.dart';
import 'package:volume_vault/shared/widgets/widget_switcher.dart';
import 'package:volume_vault/shared/hooks/paging_controller_hook.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeSectionMobile extends StatefulHookConsumerWidget {
  final VisualizationType? viewType;

  const HomeSectionMobile({super.key, this.viewType});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HomeSectionMobileState();
}

class _HomeSectionMobileState extends ConsumerState<HomeSectionMobile>
    with AutomaticKeepAliveClientMixin {
  final HomeSectionMobileCommand _commands = const HomeSectionMobileCommand();
  final BookInfoViewerCommand _bookInfoViewerCommand =
      const BookInfoViewerCommand();
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userInfo = ref.watch(userSessionAuthProvider);

    final pagingController =
        usePagingController<int, BookModel>(firstPageKey: 1);
    final tabBookFormatController = useTabController(initialLength: 10);

    final visualizationTypeState =
        useState<VisualizationType>(widget.viewType ?? VisualizationType.LIST);
    final sortOptionState = useState(BookSortOption());
    final resultLimiterState = useState<BookResultLimiter?>(null);
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

      pagingController.addPageRequestListener(bookFetcher);

      return () => pagingController.removePageRequestListener(bookFetcher);
    });

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => pagingController.refresh(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              title: WidgetSwitcher(
                first: Text(AppLocalizations.of(context)!.titleAppBarHomePage),
                second: userInfo != null
                    ? Text(AppLocalizations.of(context)!
                        .helloUserAppBarHomePage(userInfo.name))
                    : const SizedBox(),
              ),
              actions: [
                IconButton(
                    onPressed: () async =>
                        _commands.showSearchDialog(ref: ref, context: context),
                    icon: const Icon(Icons.search_rounded)),
                IconButton(
                  onPressed: () =>
                      context.push(AppRoutes.configurationsPageRoute),
                  icon: const Icon(Icons.settings_rounded),
                ),
                IconButton(
                  onPressed: () async => _commands.showProfileCard(context),
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
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(100),
                child: Column(
                  children: [
                    Flexible(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                AppLocalizations.of(context)!
                                    .bookCountStatsHomePage(
                                        bookStatsState.value?.count ?? 0),
                                style: Theme.of(context).textTheme.bodyLarge),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Badge(
                                  alignment: AlignmentDirectional.topEnd,
                                  isLabelVisible:
                                      sortOptionState.value.sort != null,
                                  smallSize: 10,
                                  child: IconButton(
                                      onPressed: () async {
                                        BookSortOption? newSortOptions =
                                            await _commands
                                                .showSortFilterDialog(context,
                                                    currentOptions:
                                                        sortOptionState.value,
                                                    wrapped: true);
                                        if (newSortOptions == null) return;
                                        sortOptionState.value = newSortOptions;

                                        pagingController.refresh();
                                      },
                                      icon: const Icon(Icons.sort_rounded)),
                                ),
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    TabBar(
                        controller: tabBookFormatController,
                        isScrollable: true,
                        onTap: (index) {
                          resultLimiterState.value = BookResultLimiter(
                              format: index != 0
                                  ? BookFormat.values[index - 1]
                                  : null);
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
                            text: L10n.bookFormat(context,
                                format: BookFormat.ebook),
                          ),
                          Tab(
                            text: L10n.bookFormat(context,
                                format: BookFormat.pocket),
                          ),
                          Tab(
                              text: L10n.bookFormat(context,
                                  format: BookFormat.audioBook)),
                          Tab(
                            text: L10n.bookFormat(context,
                                format: BookFormat.spiral),
                          ),
                          Tab(
                              text: L10n.bookFormat(context,
                                  format: BookFormat.hq)),
                          Tab(
                            text: L10n.bookFormat(context,
                                format: BookFormat.collectorsEdition),
                          ),
                        ]),
                  ],
                ),
              ),
            ),
            PaginationSliverListGrid<int, BookModel>(
              pagingController: pagingController,
              visualizationType: visualizationTypeState.value,
              itemBuilder: (_, data, index) {
                return _commands.buildBookView(context, ref,
                    book: data,
                    viewType: visualizationTypeState.value,
                    onUpdate: pagingController.refresh,
                    bookInfoViewerStrategy: _bookInfoViewerCommand,
                    onSelect: (book) async {
                  final refresh =
                      await _commands.onBookSelect(context, ref, book);
                  if (refresh) pagingController.refresh();
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: "qrCodeScanner",
            child: const Icon(Icons.qr_code_scanner_rounded),
            onPressed: () async {
              final BookModel? result = await context
                  .push<BookModel?>(AppRoutes.qrCodeScannerPageRoute);
              if (!context.mounted || result == null) return;

              context.push(AppRoutes.registerEditBookPageRoute,
                  extra: [result, false]);
            },
          ),
          OpenContainer(
            clipBehavior: Clip.none,
            openColor: Theme.of(context).colorScheme.background,
            closedColor: Theme.of(context).colorScheme.background,
            onClosed: (_) => pagingController.refresh(),
            closedShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            closedBuilder: (_, open) => FloatingActionButton.extended(
              heroTag: "addBook",
              label: Text(AppLocalizations.of(context)!.addBookFabLabel),
              icon: const Icon(Icons.add_rounded),
              onPressed: open,
            ),
            openBuilder: (_, __) => const RegisterEditBookPage(),
          ),
        ],
      ),
    );
  }
}
