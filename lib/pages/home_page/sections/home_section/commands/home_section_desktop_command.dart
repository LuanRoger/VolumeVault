import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:volume_vault/models/book_model.dart";
import "package:volume_vault/models/book_sort_option.dart";
import "package:volume_vault/pages/configuration_page/configuration_page.dart";
import "package:volume_vault/pages/home_page/sections/home_section/commands/home_section_layout_strategy.dart";
import "package:volume_vault/shared/widgets/chip/book_sort_chip_choice.dart";
import "package:volume_vault/shared/widgets/dialogs/content_dialog.dart";
import "package:volume_vault/shared/widgets/icon/icon_text.dart";
import "package:volume_vault/shared/widgets/switcher/text_switch.dart";

class HomeSectionDesktopCommand extends HomeSectionLayoutStrategy {
  late ValueNotifier<BookModel?> bookOnViwerState;

  HomeSectionDesktopCommand();

  @override
  void onBookSelect(BuildContext context, WidgetRef ref, BookModel bookModel,
      {void Function()? onUpdate}) {
    bookOnViwerState.value = bookModel;
  }

  Future<void> showConfigurationsDialog(BuildContext context) async {
    final dialog = ContentDialog(
      closeButton: true,
      heightFactor: 0.7,
      padding: const EdgeInsets.all(10),
      title: Text(
        AppLocalizations.of(context)!.configurationsAppBarTitle,
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      content: ConfigurationContent(),
    );
    await dialog.show(context);
  }

  @override
  Future<BookSortOption?> showSortFilterDialog(BuildContext context,
      {bool wrapped = true,
      BookSortOption? currentOptions,
      bool full = false}) async {
    const iconSize = 30.0;

    var update = false;
    var ascending = currentOptions?.ascending ?? true;
    var sortType = currentOptions?.sort;

    final dialog = ContentDialog(
        padding: const EdgeInsets.all(10),
        heightFactor: full ? 1 : 0.5,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              sortType = null;
              ascending = true;
              update = true;
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.sortOptionClearSort),
          ),
          const SizedBox(width: 10),
          FilledButton(
            onPressed: () {
              update = true;
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.sortOptionApplySort),
          )
        ]);

    await dialog.show(context);

    return update ? BookSortOption(sort: sortType, ascending: ascending) : null;
  }
}
