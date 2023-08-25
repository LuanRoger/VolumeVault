// ignore_for_file: lines_longer_than_80_chars

import "package:flutter/material.dart" hide BottomSheet;
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:volume_vault/l10n/formaters/time_formater.dart";
import "package:volume_vault/models/book_model.dart";
import "package:volume_vault/models/enums/book_format.dart";
import "package:volume_vault/models/enums/read_status.dart";
import "package:volume_vault/pages/register_edit_book_page/commands/book_info_getter_command.dart";
import "package:volume_vault/pages/register_edit_book_page/commands/register_edit_book_page_mobile_command.dart";
import "package:volume_vault/pages/register_edit_book_page/widgets/book_info_getter.dart";
import "package:volume_vault/providers/providers.dart";
import "package:volume_vault/shared/hooks/text_field_tags_controller_hook.dart";
import "package:volume_vault/shared/widgets/chip/chip_list.dart";
import "package:volume_vault/shared/widgets/icon/icon_text.dart";
import "package:volume_vault/shared/widgets/viewers/book_image_viewer.dart";

class RegisterEditBookPageMobile extends HookConsumerWidget {
  final RegisterEditBookPageMobileCommand _command =
      RegisterEditBookPageMobileCommand();
  final BookInfoGetterCommand _bookInfoGetterCommand = BookInfoGetterCommand();

  final BookModel? externalBookModel;
  final bool editMode;

  static final _bookInfoFormKey = GlobalKey<FormState>();
  static final _publisherInfoFormKey = GlobalKey<FormState>();
  static final _aditionalInfoFormKey = GlobalKey<FormState>();

  RegisterEditBookPageMobile(
      {super.key, this.externalBookModel, this.editMode = false});

  void validateAndPop(BuildContext context, GlobalKey<FormState> formKey) {
    final allGood = formKey.currentState!.validate();
    if (allGood) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizationPreferences =
        ref.read(localizationPreferencesStateProvider);
    final localization = localizationPreferences.localization;

    final coverUrlController =
        useTextEditingController(text: externalBookModel?.coverLink);
    // ignore: unused_local_variable
    final coverReloader = useListenable(coverUrlController);

    final titleController =
        useTextEditingController(text: externalBookModel?.title);
    final authorController =
        useTextEditingController(text: externalBookModel?.author);
    final isbnController =
        useTextEditingController(text: externalBookModel?.isbn);

    final editionController =
        useTextEditingController(text: externalBookModel?.edition?.toString());
    final publishYearController = useTextEditingController(
        text: externalBookModel?.publicationYear?.toString());
    final publisherController =
        useTextEditingController(text: externalBookModel?.publisher);

    final bookFormatState =
        useState<BookFormat>(externalBookModel?.format ?? BookFormat.hardcover);
    final buyLinkController =
        useTextEditingController(text: externalBookModel?.buyLink);
    final genreController =
        useTextfieldTagsController(genres: externalBookModel?.genre?.toList());
    final pageNumbController = useTextEditingController(
        text: externalBookModel?.pagesNumber?.toString());

    final observationController =
        useTextEditingController(text: externalBookModel?.observation);
    final synopsisController =
        useTextEditingController(text: externalBookModel?.synopsis);

    final readState = useState<ReadStatus>(
        externalBookModel?.readStatus ?? ReadStatus.notRead);
    final readStartDay = useState<DateTime?>(externalBookModel?.readStartDay);
    final readStartDayController = useTextEditingController(
        text: externalBookModel?.readStartDay != null
            ? formatDateByLocale(localization, externalBookModel!.readStartDay!)
            : null);
    final readEndDay = useState<DateTime?>(externalBookModel?.readEndDay);
    final readEndDayController = useTextEditingController(
        text: externalBookModel?.readEndDay != null
            ? formatDateByLocale(localization, externalBookModel!.readEndDay!)
            : null);
    final tagLabelsState = useState<Set<String>>(externalBookModel?.tags ?? {});
    final editMode = externalBookModel != null && this.editMode;

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
        padding: const EdgeInsets.all(8),
        child: loadingState.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                          child: GestureDetector(
                        onTap: () => _command.showImageCoverDialog(
                            context, coverUrlController),
                        child: BookImageViewer(
                          image: coverUrlController.text.isNotEmpty
                              ? NetworkImage(coverUrlController.text)
                              : null,
                          placeholder: const Icon(Icons.add_a_photo_rounded),
                        ),
                      )),
                      const SizedBox(height: 5),
                      Text(
                        AppLocalizations.of(context)!.mandatoryFieldsWarning,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontStyle: FontStyle.italic),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: BookInfoGetter(
                          bookInfoFormKey: _bookInfoFormKey,
                          publisherInfoFormKey: _publisherInfoFormKey,
                          aditionalInfoFormKey: _aditionalInfoFormKey,
                          titleController: titleController,
                          authorController: authorController,
                          isbnController: isbnController,
                          editionController: editionController,
                          publishYearController: publishYearController,
                          publisherController: publisherController,
                          bookFormat: bookFormatState,
                          buyLinkController: buyLinkController,
                          genreController: genreController,
                          pageNumbController: pageNumbController,
                          observationController: observationController,
                          synopsisController: synopsisController,
                          readStatus: readState,
                          readStartDay: readStartDay,
                          readEndDay: readEndDay,
                          readStartDayController: readStartDayController,
                          readEndDayController: readEndDayController,
                          command: _bookInfoGetterCommand,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconText(
                            icon: Icons.tag_rounded,
                            text: AppLocalizations.of(context)!
                                .tagsRegisterBookPage,
                          ),
                          FilledButton.tonal(
                            onPressed: () async {
                              final tagController = TextEditingController();
                              await _command.showAddTagDialog(
                                  context, tagController);
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
                        ],
                      ),
                      ChipList(
                        tagLabelsState.value,
                        onRemove: (value) {
                          final newLabels =
                              Set<String>.from(tagLabelsState.value)
                                ..remove(value);
                          tagLabelsState.value = newLabels;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          loadingState.value = true;
                          late bool success;
                          if (editMode) {
                            final saveInfos =
                                await _command.showConfirmEditDialog(context);
                            if (!saveInfos) {
                              loadingState.value = false;
                              return;
                            }

                            success = await _command.editBook(
                              editBookModel: externalBookModel!,
                              titleController: titleController,
                              authorController: authorController,
                              isbnController: isbnController,
                              publisherController: publisherController,
                              publishYearController: publishYearController,
                              editionController: editionController,
                              pageNumbController: pageNumbController,
                              genreController: genreController,
                              bookFormat: bookFormatState.value,
                              observationController: observationController,
                              synopsisController: synopsisController,
                              coverUrlController: coverUrlController,
                              buyLinkController: buyLinkController,
                              readState: readState.value,
                              readStartDay: readEndDay.value,
                              readEndDay: readEndDay.value,
                              tagLabels: tagLabelsState.value,
                              bookController:
                                  await ref.read(bookControllerProvider.future),
                            );
                            if (context.mounted && !success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(context)!
                                        .wasNotPossibleToUpdateTheBookSnackbarMessage,
                                  ),
                                ),
                              );
                            }
                          } else {
                            success = await _command.registerBook(
                              titleController: titleController,
                              authorController: authorController,
                              isbnController: isbnController,
                              publisherController: publisherController,
                              publishYearController: publishYearController,
                              editionController: editionController,
                              pageNumbController: pageNumbController,
                              genreController: genreController,
                              bookFormat: bookFormatState.value,
                              observationController: observationController,
                              synopsisController: synopsisController,
                              coverUrlController: coverUrlController,
                              buyLinkController: buyLinkController,
                              readState: readState.value,
                              readStartDay: readStartDay.value,
                              readEndDay: readEndDay.value,
                              tagLabels: tagLabelsState.value,
                              bookController:
                                  await ref.read(bookControllerProvider.future),
                            );

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
                          }

                          if (!success) {
                            loadingState.value = false;
                            return;
                          }

                          if (context.mounted) {
                            Navigator.pop(context, editMode);
                          }
                        },
                        child: Text(AppLocalizations.of(context)!
                            .confirmButtonRegisterBookPage),
                      )
                    ]),
              ),
      ),
    );
  }
}
