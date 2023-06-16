import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/pages/home_page/commands/home_page_desktop_commands.dart';
import 'package:volume_vault/pages/home_page/sections/home_section/layouts/home_section_desktop.dart';
import 'package:volume_vault/pages/register_edit_book_page/register_edit_book_page.dart';
import 'package:volume_vault/shared/hooks/paging_controller_hook.dart';

class HomePageDesktop extends HookConsumerWidget {
  // ignore: unused_field
  final HomePageDesktopCommands _commands = const HomePageDesktopCommands();

  const HomePageDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetcherListController =
        usePagingController<int, BookModel>(firstPageKey: 1);

    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: HomeSectionDesktop(fetcherListController),
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
          openBuilder: (_, __) => const RegisterEditBookPage(),
        ));
  }
}
