import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/enums/read_status.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import "package:volume_vault/l10n/formaters/time_formater.dart";

class ReadProgress extends StatelessWidget {
  final ReadStatus readStatus;
  final DateTime? readStartDay;
  final DateTime? readEndDay;

  const ReadProgress(
      {super.key,
      required this.readStatus,
      this.readStartDay,
      this.readEndDay});

  double calculateProgressValueByReadStatus(ReadStatus readStatus) {
    switch (readStatus) {
      case ReadStatus.reading:
        return 0.5;
      case ReadStatus.notRead:
        return 0;
      case ReadStatus.hasRead:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        LinearProgressIndicator(
            value: calculateProgressValueByReadStatus(readStatus)),
        Align(
          alignment: Alignment.centerLeft,
          child: Chip(
            label:
                Text(AppLocalizations.of(context)!.notReadedReadProgressWidget),
          ),
        ),
        if (readStatus == ReadStatus.reading ||
            readStatus == ReadStatus.hasRead)
          Align(
              alignment: Alignment.center,
              child: ProgressInfoTimeline(
                  date: readStartDay,
                  label: AppLocalizations.of(context)!
                      .readStartReadProgressWidget)),
        if (readStatus == ReadStatus.hasRead)
          Align(
              alignment: Alignment.centerRight,
              child: ProgressInfoTimeline(
                date: readEndDay,
                label: AppLocalizations.of(context)!.readEndProgressWidget,
              ))
      ],
    );
  }
}

class ProgressInfoTimeline extends ConsumerWidget {
  final String label;
  final DateTime? date;

  const ProgressInfoTimeline({super.key, required this.label, this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizationPreferences =
        ref.read(localizationPreferencesStateProvider);
    final localization = localizationPreferences.localization;

    return Chip(
      label: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(label),
            if (date != null) Text(formatDateByLocale(localization, date!)),
          ],
        ),
      ),
    );
  }
}
