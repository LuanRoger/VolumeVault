import 'package:flutter/material.dart' hide BottomSheet;
import 'package:flutter/services.dart';
import "package:go_router/go_router.dart";
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:volume_vault/l10n/l10n.dart';
import 'package:volume_vault/l10n/supported_locales.dart';
import 'package:volume_vault/models/enums/book_format.dart';
import 'package:volume_vault/models/enums/read_status.dart';
import "package:volume_vault/models/utils/aditional_info_modal_model.dart";
import "package:volume_vault/models/utils/read_date_info_modal_model.dart";
import 'package:volume_vault/shared/routes/app_routes.dart';
import "package:volume_vault/l10n/formaters/time_formater.dart";
import 'package:volume_vault/shared/validators/text_field_validator.dart';
import 'package:volume_vault/shared/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:volume_vault/shared/widgets/bottom_sheet/stateful_bottom_sheet.dart';
import 'package:volume_vault/shared/widgets/chip/book_read_chip_choice.dart';
import 'package:volume_vault/shared/widgets/chip/chip_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:volume_vault/shared/widgets/text_fields/date_text_field.dart';

class BookInfoGetterCommand {
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

  void showBookInfoModal(BuildContext context, GlobalKey<FormState> formKey,
      {TextEditingController? titleController,
      TextEditingController? authorController,
      TextEditingController? isbnController}) {
    final isbnInputFormater = MaskTextInputFormatter(
        mask: "###-##-####-###-#", type: MaskAutoCompletionType.eager);

    final titleMemento = titleController?.text ?? "";
    final authorMemento = authorController?.text ?? "";
    final isbnMemento = isbnController?.text ?? "";

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

  Future<AditionalInfoModalModel?> showAditionalInfoModal(
      BuildContext context, GlobalKey<FormState> formKey,
      {required TextfieldTagsController genreController,
      BookFormat? bookFormat,
      TextEditingController? pageNumbController,
      TextEditingController? buyLinkController}) async {
    final pageNumbMemento = pageNumbController?.text ?? "";
    final genreMemento =
        List<String>.from(genreController.getTags ?? List.empty());
    final buyLinkMemento = buyLinkController?.text ?? "";
    final bookFormatMemento = bookFormat ?? BookFormat.hardcover;
    final aditionalInfoModel =
        AditionalInfoModalModel(bookFormat: bookFormat ?? BookFormat.hardcover);
    var notSaveClose = false;

    const genreSeparator = <String>[",", ";"];

    await BottomSheet(
      action: (context) =>
          bottomSheetActions(context, () => validateAndPop(context, formKey)),
      onClose: () {
        pageNumbController?.text = pageNumbMemento;
        // ignore: omit_local_variable_types
        for (final String genre in List.from(genreMemento)) {
          genreController.addTag = genre;
        }
        buyLinkController?.text = buyLinkMemento;
        bookFormat = bookFormatMemento;
        notSaveClose = true;
      },
      items: [
        Form(
          key: formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                value: bookFormat,
                style: Theme.of(context).textTheme.bodyMedium,
                items: [
                  DropdownMenuItem(
                    value: BookFormat.hardcover,
                    child: Text(
                        L10n.bookFormat(context, format: BookFormat.hardcover)),
                  ),
                  DropdownMenuItem(
                    value: BookFormat.hardback,
                    child: Text(
                        L10n.bookFormat(context, format: BookFormat.hardback)),
                  ),
                  DropdownMenuItem(
                    value: BookFormat.paperback,
                    child: Text(
                        L10n.bookFormat(context, format: BookFormat.paperback)),
                  ),
                  DropdownMenuItem(
                    value: BookFormat.ebook,
                    child: Text(
                        L10n.bookFormat(context, format: BookFormat.ebook)),
                  ),
                  DropdownMenuItem(
                    value: BookFormat.pocket,
                    child: Text(
                        L10n.bookFormat(context, format: BookFormat.pocket)),
                  ),
                  DropdownMenuItem(
                    value: BookFormat.audioBook,
                    child: Text(
                        L10n.bookFormat(context, format: BookFormat.audioBook)),
                  ),
                  DropdownMenuItem(
                    value: BookFormat.spiral,
                    child: Text(
                        L10n.bookFormat(context, format: BookFormat.spiral)),
                  ),
                  DropdownMenuItem(
                    value: BookFormat.hq,
                    child:
                        Text(L10n.bookFormat(context, format: BookFormat.hq)),
                  ),
                  DropdownMenuItem(
                    value: BookFormat.collectorsEdition,
                    child: Text(L10n.bookFormat(context,
                        format: BookFormat.collectorsEdition)),
                  ),
                ],
                onChanged: (newValue) => aditionalInfoModel.bookFormat =
                    newValue ?? BookFormat.hardcover,
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
                initialTags: genreController.getTags ?? List.empty(),
                textSeparators: genreSeparator,
                inputfieldBuilder:
                    (context, tec, fn, error, onChanged, onSubmitted) {
                  return (context, sc, selectedTags, onTagDelete) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: tec,
                            focusNode: fn,
                            maxLength: 50,
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!
                                    .genresTextFieldHint,
                                errorText: error,
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.list_rounded),
                                  onPressed: () async {
                                    final selectedGenres = await context
                                        .push<Set<String>>(
                                            AppRoutes.selectBookGenrePageRoute,
                                            extra: [selectedTags.toSet()]);
                                    if (selectedGenres == null ||
                                        selectedGenres.isEmpty) return;

                                    for (final genre in selectedGenres) {
                                      genreController.addTag = genre;
                                    }
                                  },
                                )),
                            onChanged: onChanged,
                            onFieldSubmitted: onSubmitted,
                          ),
                          ChipList(selectedTags.toSet(), onRemove: onTagDelete)
                        ],
                      );
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
              ),
            ],
          ),
        ),
      ],
    ).show(context);

    return !notSaveClose ? aditionalInfoModel : null;
  }

  Future<ReadDateInfoModalModel?> showGetReadDatesModal(BuildContext context,
      {required ReadStatus readStatus,
      SupportedLocales? localization,
      TextEditingController? readStartDayController,
      TextEditingController? readEndDayController,
      DateTime? readStartDay,
      DateTime? readEndDay}) async {
    final localizationOption = localization ?? SupportedLocales.values[0];

    final readStartDayControllerMemento = readStartDayController?.text;
    final readEndDayControllerMemento = readEndDayController?.text;

    var notSaveClose = false;
    final readDateInfoModalModel = ReadDateInfoModalModel(
        readStatus: readStatus,
        readStartDayText: readStartDay,
        readEndDayText: readEndDay);

    await StatefulBottomSheet(
      dragable: true,
      isDismissible: true,
      isScrollControlled: false,
      action: (context) =>
          bottomSheetActions(context, () => Navigator.of(context).pop()),
      onClose: () {
        readStartDayController?.text = readStartDayControllerMemento ?? "";
        readEndDayController?.text = readEndDayControllerMemento ?? "";
        notSaveClose = true;
      },
      child: (context, setState) {
        return Column(
          children: [
            BookReadChipChoice(
              initialOption: readDateInfoModalModel.readStatus,
              onChanged: (newReadStatus) {
                readDateInfoModalModel.readStatus = newReadStatus;
                setState(() {});
              },
            ),
            DateTextField(
              label: AppLocalizations.of(context)!.readStartDayRegisterBookPage,
              controller: readStartDayController,
              enabled:
                  readDateInfoModalModel.readStatus == ReadStatus.reading ||
                      readDateInfoModalModel.readStatus == ReadStatus.hasRead,
              onDateSelected: (newDate) {
                setState(() {
                  readDateInfoModalModel.readStartDayText = newDate;
                  readStartDayController?.text =
                      formatDateByLocale(localizationOption, newDate);
                });
              },
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            ),
            const SizedBox(height: 15),
            DateTextField(
              label: AppLocalizations.of(context)!.readEndDayRegisterBookPage,
              controller: readEndDayController,
              enabled: readDateInfoModalModel.readStatus == ReadStatus.hasRead,
              onDateSelected: (newDate) {
                setState(() {
                  readDateInfoModalModel.readEndDayText = newDate;
                  readEndDayController?.text =
                      formatDateByLocale(localizationOption, newDate);
                });
              },
              initialDate: DateTime.now(),
              firstDate: readStartDay ?? DateTime.now(),
              lastDate: DateTime.now(),
            )
          ],
        );
      },
    ).show(context);

    return !notSaveClose ? readDateInfoModalModel : null;
  }
}
