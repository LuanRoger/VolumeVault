import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/pages/home_page/sections/bookmark_section.dart';
import 'package:volume_vault/pages/home_page/sections/home_section.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  Widget getSection(int index) {
    switch (index) {
      case 0:
        return HomeSection(
          viewType: VisualizationType.LIST,
        );
      case 1:
        return const BookmarkSection();
      default:
        return HomeSection(
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
    );
  }
}
