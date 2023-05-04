import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:volume_vault/models/enums/read_status.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:volume_vault/shared/widgets/chip/chip_choice.dart';

class BookReadChipChoice extends HookWidget implements ChipChoice<ReadStatus> {
  @override
  final ReadStatus initialOption;
  @override
  final bool wrapped;
  @override
  final void Function(ReadStatus)? onChanged;

  const BookReadChipChoice({
    super.key,
    this.initialOption = ReadStatus.notRead,
    this.wrapped = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final readStatus = useState<ReadStatus>(initialOption);

    return ChipsChoice<ReadStatus>.single(
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
            value: ReadStatus.notRead,
            label:
                AppLocalizations.of(context)!.notReadedStatusRegisterBookPage),
        C2Choice(
            value: ReadStatus.reading,
            label: AppLocalizations.of(context)!.readingStatusRegisterBookPage),
        C2Choice(
            value: ReadStatus.hasRead,
            label: AppLocalizations.of(context)!.readedStatusRegisterBookPage)
      ],
    );
  }
}
