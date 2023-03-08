import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/shared/fake_models.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/widgets/book_info_scrollable_tiles/book_info_list_card.dart';
import 'package:volume_vault/shared/widgets/book_viewer_card.dart';
import 'package:volume_vault/shared/widgets/search_text_field.dart';

class HomePageDesktop extends HookWidget {
  const HomePageDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedBook = useState<BookModel?>(null);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(87),
          child: Column(
            children: [
              WindowTitleBarBox(
                  child: Row(
                children: [
                  Expanded(child: MoveWindow()),
                  Flexible(flex: 0, child: MinimizeWindowButton()),
                  Flexible(flex: 0, child: MaximizeWindowButton()),
                  Flexible(flex: 0, child: CloseWindowButton()),
                ],
              )),
              AppBar(
                actions: [
                  IconButton(
                    onPressed: () => Navigator.pushNamed(
                        context, AppRoutes.configurationsPageRoute),
                    icon: const Icon(Icons.settings_rounded),
                  ),
                ],
              ),
            ],
          )),
      body: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 0,
                  child: NavigationRail(
                    leading: FloatingActionButton(
                      onPressed: () {},
                      child: const Icon(Icons.add),
                    ),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home_rounded),
                        label: Text("Inicio"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.library_books_rounded),
                        label: Text("Coleções"),
                      ),
                    ],
                    selectedIndex: 0,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final BookModel book = fakeBookModel;
                      book.title = "Livro $index";

                      return BookInfoListCard(
                        book,
                        onPressed: () => selectedBook.value = book,
                      );
                    },
                    itemCount: 10,
                  ),
                ),
                Expanded(
                  child: selectedBook.value != null
                      ? BookViewerCard(selectedBook.value!)
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
