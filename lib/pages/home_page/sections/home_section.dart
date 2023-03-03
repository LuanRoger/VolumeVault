import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/pages/register_edit_book_page/register_edit_book_page.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/get_user_book_request.dart';
import 'package:volume_vault/services/models/user_book_result.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/widgets/book_info_card.dart';
import 'package:volume_vault/shared/widgets/book_info_grid_card.dart';
import 'package:volume_vault/shared/widgets/search_text_field.dart';

class HomeSection extends HookConsumerWidget {
  VisualizationType? viewType;
  final _booksFetcherRequest = GetUserBookRequest(page: 1);
  

  HomeSection({super.key, this.viewType});

  void _onCardPress(BuildContext context, BookModel bookModel) {
    Navigator.pushNamed(context, AppRoutes.bookInfoViewerPageRoute,
        arguments: [bookModel]);
  }

  Future<UserBookResult> _fetchUserBooks(WidgetRef ref) async {
    final bookService = await ref.read(bookServiceProvider.future);
    if (bookService == null) return UserBookResult.empty();

    UserBookResult userBookResult =
        await bookService.getUserBook(_booksFetcherRequest);
    return userBookResult;
  }

  Widget _buildBookView(BuildContext context, WidgetRef ref,
      {required List<BookModel> books,
      required ScrollController controller,
      VisualizationType viewType = VisualizationType.LIST}) {
    switch (viewType) {
      case VisualizationType.LIST:
        return ListView(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            for (final book in books) BookInfoCard(
              book,
              onPressed: () => _onCardPress(context, book),
            ),],
        );
      case VisualizationType.GRID:
        return GridView(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.53),
          children: [
            for (final book in books) BookInfoGridCard(
              book,
              onPressed: () => _onCardPress(context, book),
            ),],
        );
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
    
    final fetchRelaodKey = useState(UniqueKey());
    final userBooks = useState(List<BookModel>.empty());
    final fetchMemoizer = useMemoized(() => _fetchUserBooks(ref), [fetchRelaodKey.value]);
    final fetchFuture = useFuture(fetchMemoizer);

    final lastDataPage = useState(1);
    final visualizationType =
        useState<VisualizationType>(viewType ?? VisualizationType.LIST);
    final scrollController = useScrollController();
    useEffect(
      () => () {
        scrollController.addListener(
          () {
            if (scrollController.position.maxScrollExtent !=
                scrollController.offset) return;
            if (_booksFetcherRequest.page > lastDataPage.value) return;
            _booksFetcherRequest.page += 1;
            fetchRelaodKey.value = UniqueKey();
          },
        );
      },
    );

    if (fetchFuture.hasData && fetchFuture.connectionState == ConnectionState.done) {
      if (fetchFuture.data!.books.isNotEmpty) {
        userBooks.value = [...userBooks.value, ...fetchFuture.data!.books];
        lastDataPage.value = _booksFetcherRequest.page;
      }
    }

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surfaceTint
                ], stops: const [
                  0.5,
                  1
                ]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Volume Vault",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  userInfo.maybeWhen(
                      data: (data) =>
                          Text("Olá, ${data != null ? data.username : ""}"),
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
        title: SearchTextField(height: 40),
        actions: [
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
          _booksFetcherRequest.page = 1;
          fetchRelaodKey.value = UniqueKey();
        },
        child: PageTransitionSwitcher(
          transitionBuilder: (child, animation, secondaryAnimation) =>
              FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child),
          child: _buildBookView(context, ref,
              books: userBooks.value,
              controller: scrollController,
              viewType: visualizationType.value),
        ),
      ),
      floatingActionButton: OpenContainer(
        clipBehavior: Clip.none,
        openColor: Theme.of(context).colorScheme.background,
        closedColor: Theme.of(context).colorScheme.background,
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        closedBuilder: (_, open) => FloatingActionButton(
            onPressed: open, child: const Icon(Icons.add_rounded)),
        openBuilder: (_, __) => RegisterEditBookPage(),
      ),
    );
  }
}
