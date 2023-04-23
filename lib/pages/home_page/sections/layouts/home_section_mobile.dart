import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/pages/home_page/sections/commands/home_section_mobile_command.dart';
import 'package:volume_vault/pages/register_edit_book_page/register_edit_book_page.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/get_user_book_request.dart';
import 'package:volume_vault/services/models/user_book_result.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/widgets/lists/pagination_list_grid.dart';
import 'package:volume_vault/shared/widgets/cards/search_floating_card.dart';
import 'package:volume_vault/shared/widgets/widget_switcher.dart';
import 'package:volume_vault/shared/hooks/paging_controller_hook.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeSectionMobile extends HookConsumerWidget {
  final HomeSectionMobileCommand _commands = const HomeSectionMobileCommand();

  final VisualizationType? viewType;

  const HomeSectionMobile({super.key, this.viewType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoProvider);

    final pagingController =
        usePagingController<int, BookModel>(firstPageKey: 1);

    final visualizationTypeState =
        useState<VisualizationType>(viewType ?? VisualizationType.LIST);

    final searchTextController = useTextEditingController();

    final refreshKeyState = useState(UniqueKey());
    final bookStatsMemoize = useMemoized(
        () => _commands.getUserBookStats(ref), [refreshKeyState.value]);
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
                orElse: () => const SizedBox())),
        actions: [
          IconButton(
              onPressed: () async {
                SearchFloatingCard searchFloatingCard = SearchFloatingCard(
                  controller: searchTextController,
                  search: (query, dialogContext) async => await _commands
                      .buildSearhResultTiles(query, dialogContext, ref),
                );
                await searchFloatingCard.show(context);
              },
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
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.configurationsPageRoute),
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
                      "${bookStatsFuture.hasData ? bookStatsFuture.data!.count : "-"} livros",
                      style: Theme.of(context).textTheme.bodyLarge),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.sort_rounded))
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
                    return _commands.buildBookView(context,
                        book: data,
                        viewType: visualizationTypeState.value,
                        onUpdate: pagingController.refresh,
                        onSelect: (book) async {
                      bool refresh =
                          await _commands.onBookSelect(context, book);
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
