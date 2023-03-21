import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/pages/book_info_viewer_page.dart';
import 'package:volume_vault/pages/home_page/sections/commands/home_section_desktop_commands.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/get_user_book_request.dart';
import 'package:volume_vault/shared/widgets/fetcher_list_grid.dart';
import 'package:volume_vault/shared/widgets/placeholders/no_book_selected_placeholder.dart';
import 'package:volume_vault/shared/widgets/search_text_field.dart';
import 'package:volume_vault/shared/widgets/widget_switcher.dart';

class HomeSectionDesktop extends HookConsumerWidget {
  final HomeSectionDesktopCommands _commands =
      const HomeSectionDesktopCommands();

  final FetcherListGridController<BookModel> fetcherListController;

  const HomeSectionDesktop(this.fetcherListController, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookOnViwer = useState<BookModel?>(null);
    final booksFetcherRequest = useState(GetUserBookRequest(page: 1));
    final searchTextController = useTextEditingController();
    final userInfo = ref.watch(userInfoProvider);

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
              orElse: () => const SizedBox()),
        ),
        actions: [
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
                            label: "Pesquisar livros",
                            height: 40),
                      ),
                      const SizedBox(width: 8.0),
                      Flexible(
                        flex: 0,
                        child: IconButton(
                          onPressed: () => fetcherListController.refresh(),
                          icon: const Icon(Icons.refresh_rounded),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FetcherListGrid<BookModel>(
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
                        bookOnViwer.value = book;
                        _commands.onBookSelect(context, book);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: PageTransitionSwitcher(
              transitionBuilder: (child, animation, secondaryAnimation) =>
                  FadeThroughTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      child: child),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AnimatedSize(
                    alignment: Alignment.topCenter,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutQuart,
                    child: bookOnViwer.value != null
                        ? BookInfoViwerBodyPage(
                            bookOnViwer.value!,
                            onRefresh: () async {
                              return Future.delayed(const Duration(seconds: 2));
                            },
                          )
                        : const NoBookSelectedPlaceholder(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
