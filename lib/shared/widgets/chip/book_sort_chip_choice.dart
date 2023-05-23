import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:volume_vault/models/enums/book_sort.dart';
import 'package:volume_vault/shared/widgets/chip/chip_choice.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookSortChipChoice extends HookWidget implements ChipChoice<BookSort> {
  @override
  final BookSort? initialOption;
  @override
  final bool wrapped;
  @override
  final void Function(BookSort)? onChanged;

  const BookSortChipChoice(
      {super.key, this.initialOption, this.wrapped = true, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final selectedItem = useState<BookSort?>(initialOption);

    return ChipsChoice<BookSort>.single(
      value: selectedItem.value,
      wrapped: wrapped,
      padding: const EdgeInsets.all(3.0),
      onChanged: (newValue) {
        selectedItem.value = newValue;
        onChanged?.call(newValue);
      },
      choiceItems: [
        C2Choice(
            value: BookSort.title,
            label: AppLocalizations.of(context)!.sortByTitleChip),
        C2Choice(
            value: BookSort.author,
            label: AppLocalizations.of(context)!.sortByAuthorChip),
        C2Choice(
            value: BookSort.releaseDate,
            label: AppLocalizations.of(context)!.sortByReleaseDataChip),
        C2Choice(
            value: BookSort.publisher,
            label: AppLocalizations.of(context)!.sortByPublisherChip),
        C2Choice(
            value: BookSort.genre,
            label: AppLocalizations.of(context)!.sortByGenreChip),
        C2Choice(
            value: BookSort.readStartDay,
            label: AppLocalizations.of(context)!.sortByReadStartDayChip),
        C2Choice(
            value: BookSort.readEndDay,
            label: AppLocalizations.of(context)!.sortByReadEndDayChip),
        C2Choice(
            value: BookSort.creationDate,
            label: AppLocalizations.of(context)!.sortByRegisterDateChip),
      ],
    );
  }
}
