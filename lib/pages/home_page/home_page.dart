import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/pages/home_page/sections/bookmark_section.dart';
import 'package:volume_vault/pages/home_page/sections/home_section.dart';
import 'package:volume_vault/pages/register_book_page/register_book_page.dart';
import 'package:volume_vault/shared/fake_models.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  Widget getSection(int index) {
    switch (index) {
      case 0:
        return HomeSection(
          books: List.generate(50, (index) => fakeBookModel),
          viewType: VisualizationType.LIST,
        );
      case 1:
        return const BookmarkSection();
      default:
        return HomeSection(
          books: List.generate(50, (index) => fakeBookModel),
          viewType: VisualizationType.LIST,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedSection = useState(0);

    return Scaffold(
      body: getSection(selectedSection.value),
      bottomNavigationBar: NavigationBar(
          selectedIndex: selectedSection.value,
          onDestinationSelected: (newValue) => selectedSection.value = newValue,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_rounded),
              label: "Inicio",
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_rounded),
              label: "Marcadores",
            ),
          ]),
      floatingActionButton: OpenContainer(
        clipBehavior: Clip.none,
        openColor: Theme.of(context).colorScheme.background,
        closedColor: Theme.of(context).colorScheme.background,
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        closedBuilder: (_, open) => FloatingActionButton(
            onPressed: open, child: const Icon(Icons.add_rounded)),
        openBuilder: (_, __) => RegisterBookPage(),
      ),
    );
  }
}
