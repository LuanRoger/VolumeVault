import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/pages/configuration_page.dart';
import 'package:volume_vault/pages/home_page/commands/home_page_desktop_commands.dart';
import 'package:volume_vault/pages/home_page/sections/layouts/home_section_desktop.dart';
import 'package:volume_vault/pages/register_edit_book_page/register_edit_book_page.dart';
import 'package:volume_vault/shared/hooks/fetcher_list_grid_controller_hook.dart';

class HomePageDesktop extends HookConsumerWidget {
  final HomePageDesktopCommands _commands = const HomePageDesktopCommands();

  const HomePageDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutMemoize = useMemoized(() => _commands.checkout(context, ref));
    final checkout = useFuture(checkoutMemoize);

    final fetcherListController = useFetcherListGridController<BookModel>();

    final navigationIndexState = useState(0);
    final sectionState = useState<Widget>(
      HomeSectionDesktop(fetcherListController),
    );

    return Scaffold(
      body: checkout.connectionState == ConnectionState.waiting
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Row(
              children: [
                Flexible(
                  flex: 0,
                  child: NavigationRail(
                    leading: OpenContainer(
                      clipBehavior: Clip.none,
                      openColor: Theme.of(context).colorScheme.background,
                      closedColor: Theme.of(context).colorScheme.background,
                      onClosed: (_) => fetcherListController.refresh(),
                      closedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      closedBuilder: (_, open) => FloatingActionButton(
                          onPressed: open,
                          child: const Icon(Icons.add_rounded)),
                      openBuilder: (_, __) => RegisterEditBookPage(),
                    ),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home_rounded),
                        label: Text("Início"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings_rounded),
                        label: Text("Configurações"),
                      )
                    ],
                    onDestinationSelected: (newValue) {
                      navigationIndexState.value = newValue;
                      switch (newValue) {
                        case 0:
                          sectionState.value =
                              HomeSectionDesktop(fetcherListController);
                          break;
                        case 1:
                          sectionState.value = const ConfigurationPage();
                          break;
                        default:
                          sectionState.value =
                              HomeSectionDesktop(fetcherListController);
                          break;
                      }
                    },
                    selectedIndex: navigationIndexState.value,
                  ),
                ),
                Expanded(child: sectionState.value)
              ],
            ),
    );
  }
}
