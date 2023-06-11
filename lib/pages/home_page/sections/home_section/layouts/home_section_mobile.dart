import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/book_sort_option.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/pages/home_page/sections/home_section/commands/home_section_mobile_command.dart';
import 'package:volume_vault/pages/register_edit_book_page/register_edit_book_page.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/get_user_book_request.dart';
import 'package:volume_vault/services/models/user_book_result.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/widgets/lists/pagination_list_grid.dart';
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
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userInfo = ref.watch(userSessionAuthProvider);

    final pagingController =
        usePagingController<int, BookModel>(firstPageKey: 1);

    final visualizationTypeState =
        useState<VisualizationType>(widget.viewType ?? VisualizationType.LIST);
    final sortOptionState = useState(BookSortOption());

    final refreshKeyState = useState(UniqueKey());
    final bookStatsMemoize = useMemoized(
        () => _commands.getUserBookStats(ref), [refreshKeyState.value]);
    final bookStatsFuture = useFuture(bookStatsMemoize);

    useEffect(() {
      bookFetcher(pageKey) async {
        UserBookResult result = await _commands.fetchUserBooks(
            ref, GetUserBookRequest(page: pageKey),
            sortOptions: sortOptionState.value);
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
      appBar: AppBar(
        title: WidgetSwitcher(
            first: Text(AppLocalizations.of(context)!.titleAppBarHomePage),
            second: userInfo != null
                ? Text(AppLocalizations.of(context)!
                    .helloUserAppBarHomePage(userInfo.name))
                : const SizedBox()),
        actions: [
          IconButton(
              onPressed: () async =>
                  _commands.showSearchDialog(ref: ref, context: context),
              icon: const Icon(Icons.search_rounded)),
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
          IconButton(
            onPressed: () => context.push(AppRoutes.configurationsPageRoute),
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      AppLocalizations.of(context)!.bookCountStatsHomePage(
                          bookStatsFuture.hasData
                              ? bookStatsFuture.data!.count
                              : 0),
                      style: Theme.of(context).textTheme.bodyLarge),
                  Badge(
                    alignment: AlignmentDirectional.topEnd,
                    isLabelVisible: sortOptionState.value.sort != null,
                    smallSize: 10,
                    child: IconButton(
                        onPressed: () async {
                          BookSortOption? newSortOptions =
                              await _commands.showSortFilterDialog(context,
                                  currentOptions: sortOptionState.value,
                                  wrapped: true);
                          if (newSortOptions == null) return;
                          sortOptionState.value = newSortOptions;

                          pagingController.refresh();
                        },
                        icon: const Icon(Icons.sort_rounded)),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: RefreshIndicator(
              onRefresh: () async {
                pagingController.refresh();
                refreshKeyState.value = UniqueKey();
              },
              child: PageTransitionSwitcher(
                transitionBuilder: (child, animation, secondaryAnimation) =>
                    FadeThroughTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        child: child),
                child: PaginationListGrid<int, BookModel>(
                  pagingController: pagingController,
                  visualizationType: visualizationTypeState.value,
                  itemBuilder: (_, data, index) {
                    return _commands.buildBookView(context, ref,
                        book: data,
                        viewType: visualizationTypeState.value,
                        onUpdate: pagingController.refresh,
                        onSelect: (book) async {
                      bool refresh =
                          await _commands.onBookSelect(context, ref, book);
                      if (refresh) pagingController.refresh();
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: OpenContainer(
        clipBehavior: Clip.none,
        openColor: Theme.of(context).colorScheme.background,
        closedColor: Theme.of(context).colorScheme.background,
        onClosed: (_) => pagingController.refresh(),
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        closedBuilder: (_, open) => FloatingActionButton(
            onPressed: open, child: const Icon(Icons.add_rounded)),
        openBuilder: (_, __) => RegisterEditBookPage(),
      ),
    );
  }
}
