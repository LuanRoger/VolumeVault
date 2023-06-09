import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/pages/home_page/commands/home_page_desktop_commands.dart';
import 'package:volume_vault/pages/home_page/sections/home_section/layouts/home_section_desktop.dart';
import 'package:volume_vault/pages/home_page/sections/profile_section/profile_section.dart';
import 'package:volume_vault/pages/register_edit_book_page/register_edit_book_page.dart';
import 'package:volume_vault/shared/hooks/paging_controller_hook.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePageDesktop extends HookConsumerWidget {
  // ignore: unused_field
  final HomePageDesktopCommands _commands = const HomePageDesktopCommands();

  const HomePageDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetcherListController =
        usePagingController<int, BookModel>(firstPageKey: 1);

    final navigationIndexState = useState(0);
    final pageController = usePageController(initialPage: 0);

    return Scaffold(
      body: Row(
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
                    onPressed: open, child: const Icon(Icons.add_rounded)),
                openBuilder: (_, __) => RegisterEditBookPage(),
              ),
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.home_rounded),
                  label: Text(
                      AppLocalizations.of(context)!.homeSectionLabelHomePage),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.person_rounded),
                  label:
                      Text(AppLocalizations.of(context)!.profileSectionNavBar),
                )
              ],
              onDestinationSelected: (newValue) {
                navigationIndexState.value = newValue;
                pageController.jumpToPage(newValue);
              },
              selectedIndex: navigationIndexState.value,
              labelType: NavigationRailLabelType.all,
            ),
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                HomeSectionDesktop(fetcherListController),
                ProfileSection()
              ],
            ),
          )
        ],
      ),
    );
  }
}
