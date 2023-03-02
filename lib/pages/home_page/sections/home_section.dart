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
  List<BookModel> books;
  VisualizationType? viewType;

  HomeSection({super.key, this.viewType, required this.books});

  void _onCardPress(BuildContext context, BookModel bookModel) {
    Navigator.pushNamed(context, AppRoutes.bookInfoViewerPageRoute,
        arguments: [bookModel]);
  }

  Future _fetchUserBooks(
      WidgetRef ref, GetUserBookRequest userBookRequest) async {
    final bookService = await ref.watch(bookServiceProvider.future);
    if (bookService == null) return UserBookResult.empty();

    UserBookResult userBookResult =
        await bookService.getUserBook(userBookRequest);
    return userBookResult;
  }

  Widget _buildBookView(WidgetRef ref,
      {required List<BookModel> books,
      required ScrollController controller,
      VisualizationType viewType = VisualizationType.LIST}) {
    switch (viewType) {
      case VisualizationType.LIST:
        return ListView.builder(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final BookModel book = books[index];

            return BookInfoCard(
              book,
              onPressed: () => _onCardPress(context, book),
            );
          },
          itemCount: books.length,
        );
      case VisualizationType.GRID:
        return GridView.builder(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final BookModel book = books[index];

            return BookInfoGridCard(
              book,
              onPressed: () => _onCardPress(context, book),
            );
          },
          itemCount: books.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.53),
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
    final getUserBookState = useState(GetUserBookRequest(page: 1));
    final userBooks = ref.watch(fetchUserBooksProvider(getUserBookState.value));

    final visualizationType =
        useState<VisualizationType>(viewType ?? VisualizationType.LIST);
    final scrollController = useScrollController();
    useEffect(() => () {
          scrollController.addListener(() {
            if (scrollController.position.maxScrollExtent !=
                scrollController.offset) return;

            getUserBookState.value = getUserBookState.value
                .copyWith(page: getUserBookState.value.page + 1);
            ref.refresh(fetchUserBooksProvider(getUserBookState.value));
          });
        });

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
        onRefresh: () {
          ref.refresh(fetchUserBooksProvider(getUserBookState.value));
          return Future.delayed(const Duration(seconds: 1));
        },
        child: PageTransitionSwitcher(
            transitionBuilder: (child, animation, secondaryAnimation) =>
                FadeThroughTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    child: child),
            child: userBooks.maybeWhen(
              data: (data) {
                return _buildBookView(ref,
                    books: data.books,
                    controller: scrollController,
                    viewType: visualizationType.value);
              },
              orElse: () => const Center(child: CircularProgressIndicator()),
            )),
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
