import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/book_search_result.dart';
import 'package:volume_vault/models/book_sort_option.dart';
import 'package:volume_vault/models/enums/book_sort.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/book_stats.dart';
import 'package:volume_vault/services/models/get_user_book_request.dart';
import 'package:volume_vault/services/models/user_book_result.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/widgets/cards/book_info_card.dart';
import 'package:volume_vault/shared/widgets/cards/book_info_grid_card.dart';
import 'package:volume_vault/shared/widgets/cards/book_info_list_card.dart';
import 'package:volume_vault/shared/widgets/chip/book_sort_chip_choice.dart';
import 'package:volume_vault/shared/widgets/icon/icon_text.dart';
import 'package:volume_vault/shared/widgets/list_tiles/book_search_result_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:volume_vault/shared/widgets/switcher/text_switch.dart';

abstract class HomeSectionLayoutStrategy {
  const HomeSectionLayoutStrategy();

  void onBookSelect(BuildContext context, BookModel bookModel,
      {void Function()? onUpdate});

  Future<List<BookSearchResult>> search(String query, WidgetRef ref) async {
    final bookController = await ref.read(bookControllerProvider.future);

    List<BookSearchResult> searchResult =
        await bookController.searchUserBooks(query);
    return searchResult;
  }

  Future<List<BookSearchResultTile>> buildSearhResultTiles(
      String query, BuildContext dialogContext, WidgetRef ref) async {
    return await search(query, ref).then((searchResult) => [
          for (final bookResult in searchResult)
            BookSearchResultTile(
              bookResult,
              onTap: () async {
                final bookController =
                    await ref.read(bookControllerProvider.future);
                final BookModel? book =
                    await bookController.getBookInfoById(bookResult.id);

                if (book == null) return;
                onBookSelect(dialogContext, book);
              },
            )
        ]);
  }

  Future<UserBookResult> fetchUserBooks(
      WidgetRef ref, GetUserBookRequest getUserBookRequest,
      {BookSortOption? sortOptions}) async {
    final bookController = await ref.read(bookControllerProvider.future);

    UserBookResult userBookResult = await bookController
        .getUserBooks(getUserBookRequest, sortOption: sortOptions);
    return userBookResult;
  }

  Future<BookStats> getUserBookStats(WidgetRef ref) async {
    final statsController = await ref.read(statsControllerProvider.future);

    BookStats bookStats = await statsController.getUserBooksCount();
    return bookStats;
  }

  BookInfoCard buildBookView(BuildContext context,
      {required BookModel book,
      void Function()? onUpdate,
      void Function(BookModel)? onSelect,
      VisualizationType viewType = VisualizationType.LIST}) {
    switch (viewType) {
      case VisualizationType.LIST:
        return BookInfoListCard(
          book,
          onPressed: onSelect != null
              ? () => onSelect(book)
              : () => onBookSelect(context, book, onUpdate: onUpdate),
        );
      case VisualizationType.GRID:
        return BookInfoGridCard(
          book,
          onPressed: onSelect != null
              ? () => onSelect(book)
              : () => onBookSelect(context, book, onUpdate: onUpdate),
        );
    }
  }

  Future<void> showLogoutDialog(BuildContext context, WidgetRef ref) async {
    bool exit = false;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.signoutDialogTitle),
          content: Text(AppLocalizations.of(context)!.signoutDialogMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancelDialogButton),
            ),
            TextButton(
              onPressed: () {
                exit = true;
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.exitDialogButton),
            ),
          ]),
    );

    if (exit) {
      await ref.read(userSessionNotifierProvider.notifier).clear();
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.loginPageRoute, (_) => false);
    }
  }

  Future<BookSortOption?> showSortFilterDialog(BuildContext context,
      {bool wrapped = true, BookSortOption? currentOptions}) async {
    final size = MediaQuery.of(context).size;
    final width = size.width * 0.5;
    final height = size.height * 0.7;
    const iconSize = 30.0;

    bool update = false;
    bool ascending = currentOptions?.ascending ?? true;
    BookSort? sortType = currentOptions?.sort;

    Dialog sortFilterDialog = Dialog(
      child: Container(
        padding: const EdgeInsets.all(30),
        width: width,
        height: height,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            flex: 0,
            child: IconText(
              icon: Icons.compare_arrows_rounded,
              text: "Organizar",
              iconSize: iconSize,
              textStyle: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontFamily: "Roboto"),
            ),
          ),
          const Flexible(child: Divider()),
          Expanded(
            flex: 0,
            child: Align(
              alignment: Alignment.centerRight,
              child: TextSwitch(
                text: "Cresente",
                value: ascending,
                onChanged: (newValue) => ascending = newValue,
              ),
            ),
          ),
          Expanded(
              flex: 0,
              child: BookSortChipChoice(
                initialOption: sortType,
                wrapped: wrapped,
                onChanged: (newValue) => sortType = newValue,
              )),
          Expanded(
            flex: 0,
            child: IconText(
              icon: Icons.filter_alt_rounded,
              text: "Filtrar",
              iconSize: iconSize,
              textStyle: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontFamily: "Roboto"),
            ),
          ),
          const Flexible(child: Divider()),
          const Expanded(flex: 0, child: Text("Em breve")),
          const Spacer(flex: 10),
          Expanded(
            flex: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      sortType = null;
                      ascending = true;
                      update = true;
                      Navigator.pop(context);
                    },
                    child: Text("Limpar")),
                const SizedBox(width: 10),
                FilledButton(
                    onPressed: () {
                      update = true;
                      Navigator.pop(context);
                    },
                    child: Text("Aplicar"))
              ],
            ),
          )
        ]),
      ),
    );

    await showDialog(context: context, builder: (context) => sortFilterDialog);

    return update ? BookSortOption(sort: sortType, ascending: ascending) : null;
  }
}
