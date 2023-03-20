import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/pages/book_info_viewer_page.dart';
import 'package:volume_vault/pages/home_page/sections/commands/home_section_desktop_commands.dart';
import 'package:volume_vault/pages/register_edit_book_page/register_edit_book_page.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/get_user_book_request.dart';
import 'package:volume_vault/shared/hooks/fetcher_list_grid_controller_hook.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/widgets/fetcher_list_grid.dart';
import 'package:volume_vault/shared/widgets/search_floating_card.dart';
import 'package:volume_vault/shared/widgets/widget_switcher.dart';

class HomeSectionDesktop extends HookConsumerWidget {
  final HomeSectionDesktopCommands _commands =
      const HomeSectionDesktopCommands();

  final VisualizationType? viewType;

  const HomeSectionDesktop({super.key, this.viewType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoProvider);
    final bookOnViwer = useState<BookModel?>(null);

    final fetcherListController = useFetcherListGridController<BookModel>();
    final booksFetcherRequest = useState(GetUserBookRequest(page: 1));

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
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text("Sair da conta"),
              onTap: () async => await _commands.showLogoutDialog(context, ref),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: WidgetSwitcher(
            first: const Text("Início"),
            second: userInfo.maybeWhen(
                data: (data) {
                  if (data == null) return const SizedBox();

                  return Text("Olá, ${data.username}");
                },
                loading: () => const Text("Bem-vindo(a)"),
                orElse: () => const SizedBox())),
        actions: [
          IconButton(
              onPressed: () async {
                SearchFloatingCard searchFloatingCard = SearchFloatingCard(
                  controller: searchTextController,
                  search: (query, dialogContext) => _commands
                      .buildSearhResultTiles(query, dialogContext, ref),
                );
                await searchFloatingCard.show(context);
              },
              icon: const Icon(Icons.search_rounded)),
          IconButton(
            onPressed: () {
              fetcherListController.visualizationType =
                  fetcherListController.visualizationType ==
                          VisualizationType.LIST
                      ? VisualizationType.GRID
                      : VisualizationType.LIST;
            },
            icon: Icon(fetcherListController.visualizationType ==
                    VisualizationType.LIST
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: PageTransitionSwitcher(
              transitionBuilder: (child, animation, secondaryAnimation) =>
                  FadeThroughTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      child: child),
              child: FetcherListGrid<BookModel>(
                key: ValueKey(fetcherListController.visualizationType),
                controller: fetcherListController,
                fetcher: (page) async => (await _commands.fetchUserBooks(
                        ref, GetUserBookRequest(page: page)))
                    .books,
                reachScrollBottom: (page) {
                  if (booksFetcherRequest.value.page > page) {
                    return;
                  }
                  booksFetcherRequest.value =
                      booksFetcherRequest.value.copyWith(
                    page: booksFetcherRequest.value.page + 1,
                  );
                },
                builder: (data) {
                  return _commands.buildBookView(context,
                      books: data,
                      viewType: fetcherListController.visualizationType,
                      onUpdate: fetcherListController.refresh,
                      onSelect: (book) {
                    bookOnViwer.value =
                        book.id != bookOnViwer.value?.id ? book : null;
                    _commands.onBookSelect(context, book);
                  });
                },
              ),
            ),
          ),
          if (bookOnViwer.value != null)
            Expanded(
              flex: 1,
              child: BookInfoViwerBodyPage(
                bookOnViwer.value!,
                onRefresh: () async {
                  return Future.delayed(const Duration(seconds: 2));
                },
              ),
            ),
        ],
      ),
      floatingActionButton: OpenContainer(
        clipBehavior: Clip.none,
        openColor: Theme.of(context).colorScheme.background,
        closedColor: Theme.of(context).colorScheme.background,
        onClosed: (_) => fetcherListController.refresh(),
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        closedBuilder: (_, open) => FloatingActionButton(
            onPressed: open, child: const Icon(Icons.add_rounded)),
        openBuilder: (_, __) => RegisterEditBookPage(),
      ),
    );
  }
}
