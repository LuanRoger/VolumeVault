import "package:chips_choice/chips_choice.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:volume_vault/models/enums/search_filter.dart";
import "package:volume_vault/shared/widgets/chip/chip_choice.dart";

class SearchFilterChipChoice extends HookWidget
    implements ChipChoice<SearchFilter> {
  @override
  final SearchFilter initialOption;
  @override
  final bool wrapped;
  @override
  final void Function(SearchFilter)? onChanged;

  const SearchFilterChipChoice({
    super.key,
    this.initialOption = SearchFilter.books,
    this.wrapped = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final readStatus = useState<SearchFilter>(initialOption);

    return ChipsChoice<SearchFilter>.single(
      value: readStatus.value,
      onChanged: (newValue) {
        readStatus.value = newValue;
        onChanged?.call(newValue);
      },
      wrapped: wrapped,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      choiceStyle: C2ChipStyle(
        borderRadius: BorderRadius.circular(10),
        foregroundStyle: Theme.of(context).textTheme.bodyLarge,
      ),
      choiceItems: [
        C2Choice(
            value: SearchFilter.books,
            label: AppLocalizations.of(context)!.searchFilterBook),
      ],
    );
  }
}
