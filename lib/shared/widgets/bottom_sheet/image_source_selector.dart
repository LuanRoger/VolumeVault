import "package:flutter/material.dart" hide BottomSheet;
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:image_picker/image_picker.dart";
import "package:volume_vault/shared/widgets/bottom_sheet/stateful_bottom_sheet.dart";

class ImageSourceSelector {
  Future<ImageSource?> show(BuildContext context) async {
    var selected = ImageSource.camera;
    var canceled = true;

    final selectorSheet = StatefulBottomSheet(
      dragable: true,
      isDismissible: true,
      isScrollControlled: false,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      action: (context) {
        return FilledButton(
          onPressed: () {
            canceled = false;
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.selectBottomSheetButton),
        );
      },
      child: (context, setState) {
        return SegmentedButton<ImageSource>(
          onSelectionChanged: (newValue) {
            setState(() => selected = newValue.first);
          },
          segments: [
            ButtonSegment(
              value: ImageSource.camera,
              icon: const Icon(Icons.camera_rounded),
              label: Text(AppLocalizations.of(context)!.imageSourceCamera),
            ),
            ButtonSegment(
              value: ImageSource.gallery,
              icon: const Icon(Icons.photo_rounded),
              label: Text(AppLocalizations.of(context)!.imageSourceGallery),
            ),
          ],
          selected: {selected},
        );
      },
    );

    await selectorSheet.show(context);
    return canceled ? null : selected;
  }
}
