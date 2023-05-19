import 'package:flutter/material.dart' hide BottomSheet;
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:volume_vault/l10n/l10n.dart';
import 'package:volume_vault/l10n/supported_locales.dart';
import 'package:volume_vault/models/enums/book_format.dart';
import 'package:volume_vault/models/enums/read_status.dart';
import 'package:volume_vault/shared/validators/text_field_validator.dart';
import 'package:volume_vault/shared/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:volume_vault/shared/widgets/bottom_sheet/stateful_bottom_sheet.dart';
import 'package:volume_vault/shared/widgets/chip/book_read_chip_choice.dart';
import 'package:volume_vault/shared/widgets/chip/chip_list.dart';
import 'package:volume_vault/shared/widgets/dialogs/input_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:volume_vault/shared/widgets/text_fields/date_text_field.dart';

abstract class RegisterEditBookPageStrategy {
  void validateAndPop(BuildContext context, GlobalKey<FormState> formKey) {
    bool allGood = formKey.currentState!.validate();
    if (allGood) Navigator.pop(context);
  }

  Widget bottomSheetActions(
          BuildContext context, void Function() validationCallback) =>
      FilledButton(
        onPressed: validationCallback,
        child: Text(AppLocalizations.of(context)!.saveBottomSheetButton),
      );

  Future<bool> showConfirmEditDialog(BuildContext context) async {
    bool saveUpdates = false;

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.editBookDialogTitle),
        content: Text(AppLocalizations.of(context)!.editBookDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppLocalizations.of(context)!.cancelDialogButton),
          ),
          TextButton(
            onPressed: () {
              saveUpdates = true;
              Navigator.pop(dialogContext, true);
            },
            child: Text(AppLocalizations.of(context)!.confirmDialogButton),
          ),
        ],
      ),
    );

    return saveUpdates;
  }

  Future<void> showImageCoverDialog(
      BuildContext context, TextEditingController coverTextController) async {
    await InputDialog(
      controller: coverTextController,
      icon: const Icon(Icons.image),
      title: AppLocalizations.of(context)!.bookCoverUrlInputDialogTitle,
      textFieldLabel:
          Text(AppLocalizations.of(context)!.bookCoverUrlInputDialogHint),
      prefixIcon: const Icon(Icons.link_rounded),
    ).show(context);
  }

  Future<void> showAddTagDialog(
      BuildContext context, TextEditingController tagLabelController) async {
    await InputDialog(
      controller: tagLabelController,
      icon: const Icon(Icons.tag_rounded),
      title: AppLocalizations.of(context)!.tagInputDialogTitle,
      textFieldLabel: Text(AppLocalizations.of(context)!.tagInputDialogHint),
    ).show(context);
  }

  void showBookInfoModal(BuildContext context, GlobalKey<FormState> formKey,
      {TextEditingController? titleController,
      TextEditingController? authorController,
      TextEditingController? isbnController}) {
    final isbnInputFormater = MaskTextInputFormatter(
        mask: "###-##-####-###-#", type: MaskAutoCompletionType.eager);

    String titleMemento = titleController?.text ?? "";
    String authorMemento = authorController?.text ?? "";
    String isbnMemento = isbnController?.text ?? "";

    BottomSheet(
      action: (context) =>
          bottomSheetActions(context, () => validateAndPop(context, formKey)),
      onClose: () {
        titleController?.text = titleMemento;
        authorController?.text = authorMemento;
        isbnController?.text = isbnMemento;
      },
      items: [
        Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                validator: mandatoryNotEmpty,
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.bookTitleTextFieldHint),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: authorController,
                validator: mandatoryNotEmpty,
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.authorTextFieldHint),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: isbnController,
                validator: mandatoryNotEmptyExactLenght17,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.isbnTextFieldHint),
                keyboardType: TextInputType.number,
                inputFormatters: [isbnInputFormater],
              ),
            ],
          ),
        ),
      ],
    ).show(context);
  }

  void showPublisherInfoModal(
      BuildContext context, GlobalKey<FormState> formKey,
      {TextEditingController? publisherController,
      TextEditingController? publishYearController,
      TextEditingController? editionController}) {
    String publisherMemento = publisherController?.text ?? "";
    String publishYearMemento = publishYearController?.text ?? "";
    String editionMemento = editionController?.text ?? "";

    BottomSheet(
      action: (context) =>
          bottomSheetActions(context, () => validateAndPop(context, formKey)),
      onClose: () {
        publisherController?.text = publisherMemento;
        publishYearController?.text = publishYearMemento;
        editionController?.text = editionMemento;
      },
      items: [
        Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: publisherController,
                validator: maximumLenght100,
                maxLength: 100,
                maxLines: 1,
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.publisherTextFieldHint),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: publishYearController,
                validator: greaterThanOrEqualTo1,
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.releaseYearTextFieldHint),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: editionController,
                validator: greaterThanOrEqualTo1,
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.editionTextFieldHint),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
        ),
      ],
    ).show(context);
  }

  void showAditionalInfoModal(
      BuildContext context, GlobalKey<FormState> formKey,
      {ValueNotifier<BookFormat>? bookFormat,
      TextEditingController? pageNumbController,
      required TextfieldTagsController genreController,
      required List<String> genreTags,
      TextEditingController? buyLinkController}) {
    String pageNumbMemento = pageNumbController?.text ?? "";
    List<String> genreMemento = List.from(genreTags);
    String buyLinkMemento = buyLinkController?.text ?? "";
    BookFormat? bookFormatMemento = bookFormat?.value ?? BookFormat.hardcover;

    const List<String> genreSeparator = [",", ";"];

    BottomSheet(
      action: (context) =>
          bottomSheetActions(context, () => validateAndPop(context, formKey)),
      onClose: () {
        pageNumbController?.text = pageNumbMemento;
        for (var genre in List.from(genreMemento)) {
          genreController.addTag = genre;
        }
        buyLinkController?.text = buyLinkMemento;
        bookFormat?.value = bookFormatMemento;
      },
      items: [
        Form(
          key: formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                value: bookFormat?.value,
                validator: null,
                style: Theme.of(context).textTheme.bodyMedium,
                items: [
                  DropdownMenuItem(
                    value: BookFormat.hardcover,
                    child: Text(AppLocalizations.of(context)!
                        .hardcoverRegisterBookFormatOption),
                  ),
                  DropdownMenuItem(
                    value: BookFormat.hardback,
                    child: Text(AppLocalizations.of(context)!
                        .hardbackRegisterBookFormatOption),
                  ),
                  DropdownMenuItem(
                    value: BookFormat.paperback,
                    child: Text(AppLocalizations.of(context)!
                        .paperbackRegisterBookFormatOption),
                  ),
                  DropdownMenuItem(
                    value: BookFormat.ebook,
                    child: Text(AppLocalizations.of(context)!
                        .ebookRegisterBookFormatOption),
                  )
                ],
                onChanged: (newValue) =>
                    bookFormat?.value = newValue ?? BookFormat.hardcover,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: pageNumbController,
                validator: greaterThanOrEqualTo1,
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.pageNumbersTextFieldHint),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 15),
              TextFieldTags(
                textfieldTagsController: genreController,
                validator: (String genre) => notEmptyAndNotMustNotRepeat(
                    genre, genreController.getTags ?? List.empty()),
                initialTags: genreTags,
                textSeparators: genreSeparator,
                inputfieldBuilder:
                    (context, tec, fn, error, onChanged, onSubmitted) {
                  return ((context, sc, tags, onTagDelete) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: tec,
                            focusNode: fn,
                            maxLength: 50,
                            maxLines: 1,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!
                                  .genresTextFieldHint,
                              errorText: error,
                            ),
                            enableSuggestions: true,
                            autocorrect: true,
                            enableIMEPersonalizedLearning: true,
                            onChanged: onChanged,
                            onFieldSubmitted: onSubmitted,
                          ),
                          ChipList(tags.toSet(), onRemove: onTagDelete)
                        ],
                      ));
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: buyLinkController,
                validator: maximumLenght500,
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.buyLinkTextFieldHint),
                maxLength: 500,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    ).show(context);
  }

  void showGetReadDatesModal(BuildContext context,
      {SupportedLocales? localization,
      required ValueNotifier<ReadStatus> readStatus,
      TextEditingController? readStartDayController,
      TextEditingController? readEndDayController,
      ValueNotifier<DateTime?>? readStartDay,
      ValueNotifier<DateTime?>? readEndDay}) async {
    final SupportedLocales localizationOption =
        localization ?? SupportedLocales.values[0];

    ReadStatus readStatusMemento = readStatus.value;
    String? readStartDayControllerMemento = readStartDayController?.text;
    String? readEndDayControllerMemento = readEndDayController?.text;
    DateTime? readStartDayMemento = readStartDay?.value;
    DateTime? readEndDayMemento = readEndDay?.value;

    await StatefulBottomSheet(
      dragable: true,
      isDismissible: true,
      isScrollControlled: false,
      action: (context) =>
          bottomSheetActions(context, () => Navigator.of(context).pop()),
      onClose: () {
        readStatus.value = readStatusMemento;
        readStartDayController?.text = readStartDayControllerMemento ?? "";
        readEndDayController?.text = readEndDayControllerMemento ?? "";
        if (readStartDayMemento != null) {
          readStartDay?.value = readStartDayMemento;
        }
        if (readEndDayMemento != null) {
          readEndDay?.value = readEndDayMemento;
        }
      },
      child: (context, setState) {
        return Column(
          children: [
            BookReadChipChoice(
              initialOption: readStatus.value,
              onChanged: (newReadStatus) {
                readStatus.value = newReadStatus;
                setState(() {});
              },
            ),
            DateTextField(
              label: AppLocalizations.of(context)!.readStartDayRegisterBookPage,
              controller: readStartDayController,
              enabled: readStatus.value == ReadStatus.reading ||
                  readStatus.value == ReadStatus.hasRead,
              onDateSelected: (newDate) {
                readStartDay?.value = newDate;
                readStartDayController?.text =
                    L10n.formatDateByLocale(localizationOption, newDate);
              },
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            ),
            const SizedBox(height: 15),
            DateTextField(
              label: AppLocalizations.of(context)!.readEndDayRegisterBookPage,
              controller: readEndDayController,
              enabled: readStatus.value == ReadStatus.hasRead,
              onDateSelected: (newDate) {
                readEndDay?.value = newDate;
                readEndDayController?.text =
                    L10n.formatDateByLocale(localizationOption, newDate);
              },
              initialDate: DateTime.now(),
              firstDate: readStartDay?.value ?? DateTime.now(),
              lastDate: DateTime.now(),
            )
          ],
        );
      },
    ).show(context);
  }
}
