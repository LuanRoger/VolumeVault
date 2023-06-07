import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/pages/home_page/commands/home_page_mobile_command.dart';
import 'package:volume_vault/pages/home_page/sections/home_section/layouts/home_section_mobile.dart';
import 'package:volume_vault/pages/home_page/sections/profile_section/profile_section.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePageMobile extends HookWidget {
  // ignore: unused_field
  final HomePageMobileCommands _commands = const HomePageMobileCommands();

  const HomePageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(initialPage: 0);
    final pageIndexState = useState(0);

    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const HomeSectionMobile(
            viewType: VisualizationType.LIST,
          ),
          ProfileSection()
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: pageIndexState.value,
        onDestinationSelected: (newDestination) {
          pageIndexState.value = newDestination;
          pageController.jumpToPage(newDestination);
        },
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.homeSectionNavBar),
          NavigationDestination(
              icon: const Icon(Icons.person_rounded),
              label: AppLocalizations.of(context)!.profileSectionNavBar),
        ],
      ),
    );
  }
}
