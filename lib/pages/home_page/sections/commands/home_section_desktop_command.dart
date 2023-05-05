import 'package:flutter/material.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/book_sort_option.dart';
import 'package:volume_vault/models/enums/book_sort.dart';
import 'package:volume_vault/pages/home_page/sections/commands/home_section_layout_strategy.dart';
import 'package:volume_vault/shared/widgets/chip/book_sort_chip_choice.dart';
import 'package:volume_vault/shared/widgets/icon/icon_text.dart';
import 'package:volume_vault/shared/widgets/switcher/text_switch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeSectionDesktopCommand extends HomeSectionLayoutStrategy {
  late ValueNotifier<BookModel?> bookOnViwerState;

  HomeSectionDesktopCommand();

  @override
  void onBookSelect(BuildContext context, BookModel bookModel,
      {void Function()? onUpdate}) {
    bookOnViwerState.value = bookModel;
  }

  @override
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
                  child:
                      Text(AppLocalizations.of(context)!.sortOptionClearSort),
                ),
                const SizedBox(width: 10),
                FilledButton(
                    onPressed: () {
                      update = true;
                      Navigator.pop(context);
                    },
                    child:
                        Text(AppLocalizations.of(context)!.sortOptionApplySort))
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
