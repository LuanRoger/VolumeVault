import 'package:flutter/material.dart' hide BottomSheet;
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:volume_vault/l10n/l10n.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/enums/book_format.dart';
import 'package:volume_vault/models/enums/read_status.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/edit_book_request.dart';
import 'package:volume_vault/services/models/register_book_request.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/validators/text_field_validator.dart';
import 'package:volume_vault/shared/widgets/chip/chip_list.dart';
import 'package:volume_vault/shared/widgets/viewers/book_image_viewer.dart';
import 'package:volume_vault/shared/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:volume_vault/shared/widgets/cards/title_card.dart';
import 'package:volume_vault/shared/widgets/text_fields/date_text_field.dart';
import 'package:volume_vault/shared/widgets/dialogs/input_dialog.dart';
import 'package:volume_vault/shared/widgets/icon/icon_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:volume_vault/shared/widgets/radio/radio_text.dart';

class RegisterEditBookPage extends HookConsumerWidget {
  ///If this model is not null, the page enter in edit mode.
  ///So when you hit the save button, the book will be updated instead of created.
  final BookModel? editBookModel;

  final _bookInfoFormKey = GlobalKey<FormState>();
  final _publisherInfoFormKey = GlobalKey<FormState>();
  final _aditionalInfoFormKey = GlobalKey<FormState>();

  RegisterEditBookPage({super.key, this.editBookModel});

  Future<bool> _showConfirmEditDialog(BuildContext context) async {
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

  Future _showImageCoverDialog(
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

  Future _showAddTagDialog(
      BuildContext context, TextEditingController tagLabelController) async {
    await InputDialog(
      controller: tagLabelController,
      icon: const Icon(Icons.tag_rounded),
      title: AppLocalizations.of(context)!.tagInputDialogTitle,
      textFieldLabel: Text(AppLocalizations.of(context)!.tagInputDialogHint),
    ).show(context);
  }

  void validateAndPop(BuildContext context, GlobalKey<FormState> formKey) {
    bool allGood = formKey.currentState!.validate();
    if (allGood) Navigator.pop(context);
  }

  void _showBookInfoModal(BuildContext context,
      {TextEditingController? titleController,
      TextEditingController? authorController,
      TextEditingController? isbnController}) {
    final isbnInputFormater = MaskTextInputFormatter(
        mask: "###-##-####-###-#", type: MaskAutoCompletionType.eager);

    String titleMemento = titleController?.text ?? "";
    String authorMemento = authorController?.text ?? "";
    String isbnMemento = isbnController?.text ?? "";

    BottomSheet(
      action: (context) => FilledButton(
          onPressed: () => validateAndPop(context, _bookInfoFormKey),
          child: Text(AppLocalizations.of(context)!.saveBottomSheetButton)),
      onClose: () {
        titleController?.text = titleMemento;
        authorController?.text = authorMemento;
        isbnController?.text = isbnMemento;
      },
      items: [
        Form(
          key: _bookInfoFormKey,
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

  void _showPublisherInfoModal(BuildContext context,
      {TextEditingController? publisherController,
      TextEditingController? publishYearController,
      TextEditingController? editionController}) {
    String publisherMemento = publisherController?.text ?? "";
    String publishYearMemento = publishYearController?.text ?? "";
    String editionMemento = editionController?.text ?? "";

    BottomSheet(
      action: (context) => FilledButton(
          onPressed: () => validateAndPop(context, _publisherInfoFormKey),
          child: Text(AppLocalizations.of(context)!.saveBottomSheetButton)),
      onClose: () {
        publisherController?.text = publisherMemento;
        publishYearController?.text = publishYearMemento;
        editionController?.text = editionMemento;
      },
      items: [
        Form(
          key: _publisherInfoFormKey,
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

  void _showAditionalInfoModal(BuildContext context,
      {ValueNotifier<BookFormat>? bookFormat,
      TextEditingController? pageNumbController,
      TextEditingController? genreController,
      TextEditingController? buyLinkController}) {
    String pageNumbMemento = pageNumbController?.text ?? "";
    String genreMemento = genreController?.text ?? "";
    String buyLinkMemento = buyLinkController?.text ?? "";
    BookFormat? bookFormatMemento = bookFormat?.value ?? BookFormat.hardcover;

    BottomSheet(
      action: (context) => FilledButton(
        onPressed: () => validateAndPop(context, _aditionalInfoFormKey),
        child: Text(AppLocalizations.of(context)!.saveBottomSheetButton),
      ),
      onClose: () {
        pageNumbController?.text = pageNumbMemento;
        genreController?.text = genreMemento;
        buyLinkController?.text = buyLinkMemento;
        bookFormat?.value = bookFormatMemento;
      },
      items: [
        Form(
          key: _aditionalInfoFormKey,
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
              TextFormField(
                controller: genreController,
                validator: maximumLenght50,
                maxLength: 50,
                maxLines: 1,
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.genreTextFieldHint),
                enableSuggestions: true,
                autocorrect: true,
                enableIMEPersonalizedLearning: true,
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizationPreferences =
        ref.read(localizationPreferencesStateProvider);

    final coverUrlController =
        useTextEditingController(text: editBookModel?.coverLink);
    // ignore: unused_local_variable
    final coverReloader = useListenable(coverUrlController);

    final titleController =
        useTextEditingController(text: editBookModel?.title);
    final authorController =
        useTextEditingController(text: editBookModel?.author);
    final isbnController = useTextEditingController(text: editBookModel?.isbn);

    final editionController =
        useTextEditingController(text: editBookModel?.edition?.toString());
    final publishYearController = useTextEditingController(
        text: editBookModel?.publicationYear?.toString());
    final publisherController =
        useTextEditingController(text: editBookModel?.publisher);

    final bookFormatState =
        useState<BookFormat>(editBookModel?.format ?? BookFormat.hardcover);
    final buyLinkController =
        useTextEditingController(text: editBookModel?.buyLink);
    final genreController =
        useTextEditingController(text: editBookModel?.genre);
    final pageNumbController =
        useTextEditingController(text: editBookModel?.pagesNumber?.toString());

    final observationController =
        useTextEditingController(text: editBookModel?.observation);
    final synopsisController =
        useTextEditingController(text: editBookModel?.synopsis);

    final readState =
        useState<ReadStatus>(editBookModel?.readStatus ?? ReadStatus.notRead);
    final readStartDay = useState<DateTime?>(editBookModel?.readStartDay);
    final readStartDayController = useTextEditingController(
        text: editBookModel?.readStartDay != null
            ? L10n.formatDateByLocale(localizationPreferences.localization,
                editBookModel!.readStartDay!)
            : null);
    final readEndDay = useState<DateTime?>(editBookModel?.readEndDay);
    final readEndDayController = useTextEditingController(
        text: editBookModel?.readEndDay != null
            ? L10n.formatDateByLocale(localizationPreferences.localization,
                editBookModel!.readEndDay!)
            : null);
    final tagLabelsState = useState<Set<String>>(editBookModel?.tags ?? {});
    final editMode = editBookModel != null;

    final loadingState = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          !editMode
              ? AppLocalizations.of(context)!.newBookAppBarTitle
              : AppLocalizations.of(context)!.editBookAppBarTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: loadingState.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () => _showImageCoverDialog(
                                context, coverUrlController),
                            child: BookImageViewer(
                              image: NetworkImage(coverUrlController.text),
                            ),
                          )),
                      const SizedBox(height: 5.0),
                      Text(
                        AppLocalizations.of(context)!.mandatoryFieldsWarning,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontStyle: FontStyle.italic),
                      ),
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          ListTile(
                            leading: const Icon(Icons.book_rounded),
                            title: Text(AppLocalizations.of(context)!
                                .bookInformationRegisterBookPage),
                            trailing: const Icon(Icons.navigate_next_rounded),
                            onTap: () => _showBookInfoModal(context,
                                titleController: titleController,
                                authorController: authorController,
                                isbnController: isbnController),
                          ),
                          ListTile(
                            leading: const Icon(Icons.business_rounded),
                            title: Text(AppLocalizations.of(context)!
                                .publisherInformationRegisterBookPage),
                            trailing: const Icon(Icons.navigate_next_rounded),
                            onTap: () => _showPublisherInfoModal(context,
                                publisherController: publisherController,
                                publishYearController: publishYearController,
                                editionController: editionController),
                          ),
                          ListTile(
                            leading: const Icon(Icons.info_rounded),
                            title: Text(AppLocalizations.of(context)!
                                .aditionalInformationRegisterBookPage),
                            trailing: const Icon(Icons.navigate_next_rounded),
                            onTap: () => _showAditionalInfoModal(
                              context,
                              bookFormat: bookFormatState,
                              buyLinkController: buyLinkController,
                              genreController: genreController,
                              pageNumbController: pageNumbController,
                            ),
                          ),
                          ListTile(
                              leading: const Icon(Icons.text_snippet_rounded),
                              title: Text(AppLocalizations.of(context)!
                                  .synopsisAndObservationsRegisterBookPage),
                              trailing: const Icon(Icons.navigate_next_rounded),
                              onTap: () async {
                                final List<String>? observationSynopsisValue =
                                    await Navigator.pushNamed(context,
                                        AppRoutes.largeInfoInputPageRoute,
                                        arguments: [
                                      observationController.text,
                                      synopsisController.text
                                    ]);
                                if (observationSynopsisValue == null ||
                                    observationSynopsisValue.length != 2) {
                                  return;
                                }

                                observationController.text =
                                    observationSynopsisValue[0];
                                synopsisController.text =
                                    observationSynopsisValue[1];
                              }),
                          TitleCard(
                            title: Text(
                              AppLocalizations.of(context)!
                                  .readStatusRegisterBookPage,
                            ),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RadioText(
                                      text: AppLocalizations.of(context)!
                                          .notReadedStatusRegisterBookPage,
                                      value: ReadStatus.notRead,
                                      groupValue: readState.value,
                                      onChanged: (_) =>
                                          readState.value = ReadStatus.notRead,
                                    ),
                                    RadioText(
                                      text: AppLocalizations.of(context)!
                                          .readingStatusRegisterBookPage,
                                      value: ReadStatus.reading,
                                      groupValue: readState.value,
                                      onChanged: (_) =>
                                          readState.value = ReadStatus.reading,
                                    ),
                                    RadioText(
                                      text: AppLocalizations.of(context)!
                                          .readedStatusRegisterBookPage,
                                      value: ReadStatus.hasRead,
                                      groupValue: readState.value,
                                      onChanged: (_) =>
                                          readState.value = ReadStatus.hasRead,
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (readState.value == ReadStatus.reading ||
                                        readState.value == ReadStatus.hasRead)
                                      Expanded(
                                        flex: 10,
                                        child: DateTextField(
                                          label: AppLocalizations.of(context)!
                                              .readStartDayRegisterBookPage,
                                          controller: readStartDayController,
                                          onDateSelected: (newDate) {
                                            final localizationPreferences =
                                                ref.read(
                                                    localizationPreferencesStateProvider);

                                            readStartDay.value = newDate;
                                            readStartDayController.text =
                                                L10n.formatDateByLocale(
                                                    localizationPreferences
                                                        .localization,
                                                    newDate);
                                          },
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                        ),
                                      ),
                                    if (readState.value == ReadStatus.hasRead)
                                      const Spacer(),
                                    if (readState.value == ReadStatus.hasRead)
                                      Expanded(
                                        flex: 10,
                                        child: DateTextField(
                                          label: AppLocalizations.of(context)!
                                              .readEndDayRegisterBookPage,
                                          controller: readEndDayController,
                                          onDateSelected: (newDate) {
                                            readEndDay.value = newDate;
                                            readEndDayController.text =
                                                L10n.formatDateByLocale(
                                                    localizationPreferences
                                                        .localization,
                                                    newDate);
                                          },
                                          initialDate: DateTime.now(),
                                          firstDate: readStartDay.value ??
                                              DateTime.now(),
                                          lastDate: DateTime.now(),
                                        ),
                                      )
                                  ],
                                )
                              ],
                            ),
                          ),
                          IconText(
                            icon: Icons.tag_rounded,
                            text: AppLocalizations.of(context)!
                                .tagsRegisterBookPage,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FilledButton.tonal(
                              onPressed: () async {
                                TextEditingController tagController =
                                    TextEditingController();
                                await _showAddTagDialog(context, tagController);
                                if (tagController.text.isEmpty ||
                                    tagLabelsState.value
                                        .contains(tagController.text)) {
                                  return;
                                }

                                tagLabelsState.value = {
                                  ...tagLabelsState.value,
                                  tagController.text
                                };

                                tagController.dispose();
                              },
                              child: Text(AppLocalizations.of(context)!
                                  .addTagButtonRegisterBookPage),
                            ),
                          ),
                          ChipList(
                            tagLabelsState.value,
                            onRemove: (value) {
                              Set<String> newLabels =
                                  Set.from(tagLabelsState.value);
                              newLabels.remove(value);
                              tagLabelsState.value = newLabels;
                            },
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              loadingState.value = true;
                              final bookController =
                                  await ref.read(bookControllerProvider.future);

                              if (editMode) {
                                final updatedBook = EditBookRequest(
                                  title: titleController.text.isNotEmpty
                                      ? titleController.text
                                      : null,
                                  author: authorController.text.isNotEmpty
                                      ? authorController.text
                                      : null,
                                  isbn: isbnController.text.isNotEmpty
                                      ? isbnController.text
                                      : null,
                                  publicationYear:
                                      int.tryParse(publishYearController.text),
                                  publisher: publisherController.text.isNotEmpty
                                      ? publisherController.text
                                      : null,
                                  edition: int.tryParse(editionController.text),
                                  pagesNumber:
                                      int.tryParse(pageNumbController.text),
                                  genre: genreController.text.isNotEmpty
                                      ? genreController.text
                                      : null,
                                  format: bookFormatState.value.index,
                                  observation:
                                      observationController.text.isNotEmpty
                                          ? observationController.text
                                          : null,
                                  synopsis: synopsisController.text.isNotEmpty
                                      ? synopsisController.text
                                      : null,
                                  coverLink: coverUrlController.text.isNotEmpty
                                      ? coverUrlController.text
                                      : null,
                                  buyLink: buyLinkController.text.isNotEmpty
                                      ? buyLinkController.text
                                      : null,
                                  readStatus: readState.value,
                                  readStartDay: readState.value ==
                                              ReadStatus.reading ||
                                          readState.value == ReadStatus.hasRead
                                      ? readStartDay.value?.toUtc()
                                      : null,
                                  readEndDay:
                                      readState.value == ReadStatus.hasRead
                                          ? readEndDay.value?.toUtc()
                                          : null,
                                  tags: tagLabelsState.value.isNotEmpty
                                      ? tagLabelsState.value
                                      : null,
                                  lastModification: DateTime.now().toUtc(),
                                );
                                final bool saveInfos =
                                    await _showConfirmEditDialog(context);
                                if (!saveInfos) return;

                                final updateResult =
                                    await bookController.updateBookInfo(
                                        editBookModel!.id, updatedBook);
                                if (!updateResult) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(AppLocalizations.of(
                                              context)!
                                          .wasNotPossibleToUpdateTheBookSnackbarMessage),
                                    ),
                                  );
                                  return;
                                }

                                Navigator.pop(context, true);
                                return;
                              }

                              final RegisterBookRequest newBook =
                                  RegisterBookRequest(
                                title: titleController.text,
                                author: authorController.text,
                                isbn: isbnController.text,
                                publisher: publisherController.text.isNotEmpty
                                    ? publisherController.text
                                    : null,
                                publicationYear:
                                    int.tryParse(publishYearController.text),
                                edition: int.tryParse(editionController.text),
                                format: bookFormatState.value.index,
                                genre: genreController.text.isNotEmpty
                                    ? genreController.text
                                    : null,
                                pagesNumber:
                                    int.tryParse(pageNumbController.text),
                                observation:
                                    observationController.text.isNotEmpty
                                        ? observationController.text
                                        : null,
                                synopsis: synopsisController.text.isNotEmpty
                                    ? synopsisController.text
                                    : null,
                                readStatus: readState.value,
                                readStartDay: readState.value ==
                                            ReadStatus.reading ||
                                        readState.value == ReadStatus.hasRead
                                    ? readStartDay.value
                                    : null,
                                readEndDay:
                                    readState.value == ReadStatus.hasRead
                                        ? readEndDay.value
                                        : null,
                                tags: tagLabelsState.value.isNotEmpty
                                    ? tagLabelsState.value
                                    : null,
                                coverLink: coverUrlController.text.isNotEmpty
                                    ? coverUrlController.text
                                    : null,
                                buyLink: buyLinkController.text.isNotEmpty
                                    ? buyLinkController.text
                                    : null,
                                createdAt: DateTime.now().toUtc(),
                                lastModification: DateTime.now().toUtc(),
                              );

                              final bool success = (await bookController
                                      .registerBook(newBook)) !=
                                  null;

                              // ignore: use_build_context_synchronously
                              if (!context.mounted) return;
                              if (!success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(AppLocalizations.of(context)!
                                        .registerBookErrorSnackbarMessage),
                                  ),
                                );
                                loadingState.value = false;
                                return;
                              }

                              Navigator.pop(context);
                            },
                            child: Text(AppLocalizations.of(context)!
                                .confirmButtonRegisterBookPage),
                          )
                        ],
                      )
                    ]),
              ),
      ),
    );
  }
}
