import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:volume_vault/models/book_model.dart";
import "package:volume_vault/pages/home_page/commands/home_page_desktop_commands.dart";
import "package:volume_vault/pages/home_page/sections/home_section/layouts/home_section_desktop.dart";
import "package:volume_vault/pages/register_edit_book_page/register_edit_book_page.dart";
import "package:volume_vault/shared/hooks/paging_controller_hook.dart";
import "package:volume_vault/shared/routes/app_routes.dart";

class HomePageDesktop extends HookConsumerWidget {
  // ignore: unused_element
  HomePageDesktopCommands get _commands => const HomePageDesktopCommands();

  const HomePageDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetcherListController =
        usePagingController<int, BookModel>(firstPageKey: 1);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: HomeSectionDesktop(fetcherListController),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: "qrCodeScanner",
            child: const Icon(Icons.qr_code_scanner_rounded),
            onPressed: () async {
              final result = await context
                  .push<BookModel?>(AppRoutes.qrCodeScannerPageRoute);
              // ignore: use_build_context_synchronously
              if (!context.mounted || result == null) return;

              await context.push(AppRoutes.registerEditBookPageRoute,
                  extra: [result, false]);
            },
          ),
          OpenContainer(
            clipBehavior: Clip.none,
            openColor: Theme.of(context).colorScheme.background,
            closedColor: Theme.of(context).colorScheme.background,
            onClosed: (_) => fetcherListController.refresh(),
            closedShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            closedBuilder: (_, open) => FloatingActionButton.extended(
              heroTag: "addBook",
              label: Text(AppLocalizations.of(context)!.addBookFabLabel),
              icon: const Icon(Icons.add_rounded),
              onPressed: open,
            ),
            openBuilder: (_, __) => const RegisterEditBookPage(),
          ),
        ],
      ),
    );
  }
}
