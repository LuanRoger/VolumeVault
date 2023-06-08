import 'package:flutter/material.dart' hide BottomSheet;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/book_sort_option.dart';
import 'package:volume_vault/models/enums/book_sort.dart';
import 'package:volume_vault/pages/home_page/sections/home_section/commands/home_section_layout_strategy.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:volume_vault/shared/widgets/cards/search_floating_card.dart';
import 'package:volume_vault/shared/widgets/chip/book_sort_chip_choice.dart';
import 'package:volume_vault/shared/widgets/switcher/text_switch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeSectionMobileCommand extends HomeSectionLayoutStrategy {
  const HomeSectionMobileCommand();

  @override
  Future<bool> onBookSelect(
      BuildContext context, WidgetRef ref, BookModel bookModel,
      {void Function()? onUpdate}) async {
    onChipSelected(String searchText, BuildContext context) async =>
        await showSearchDialog(searchText: searchText, context: context, ref: ref);

    return await Navigator.pushNamed<bool>(
        context, AppRoutes.bookInfoViewerPageRoute,
        arguments: [
          bookModel,
          onChipSelected,
        ]).then((hasChange) {
      if (hasChange == null) return false;

      onUpdate?.call();
      return hasChange;
    });
  }

  @override
  Future<BookSortOption?> showSortFilterDialog(BuildContext context,
      {bool wrapped = true, BookSortOption? currentOptions}) async {
    bool update = false;
    bool ascending = currentOptions?.ascending ?? true;
    BookSort? sortType = currentOptions?.sort;

    BottomSheet filterSheet = BottomSheet(
        isScrollControlled: false,
        isDismissible: true,
        dragable: true,
        padding: 5.0,
        action: (context) => FilledButton(
              onPressed: () {
                update = true;
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.sortOptionApplySort),
            ),
        items: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextSwitch(
                text: AppLocalizations.of(context)!.sortOptionAscending,
                value: ascending,
                onChanged: (newValue) => ascending = newValue,
              ),
              ElevatedButton(
                onPressed: () {
                  sortType = null;
                  ascending = true;
                  update = true;
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.sortOptionClearSort),
              ),
            ],
          ),
          BookSortChipChoice(
            initialOption: sortType,
            wrapped: wrapped,
            onChanged: (newValue) => sortType = newValue,
          ),
        ]);
    await filterSheet.show(context);

    return update ? BookSortOption(sort: sortType, ascending: ascending) : null;
  }

  Future<void> showSearchDialog({
    String searchText = "",
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    SearchFloatingCard searchFloatingCard = SearchFloatingCard(
      initialSearch: searchText,
      search: (query) => search(query, ref),
      searchResultBuilder: (query, dialogContext) =>
          buildSearhResultTiles(query, dialogContext, ref),
    );
    await searchFloatingCard.show(context);
  }
}
