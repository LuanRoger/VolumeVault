import 'package:flutter/material.dart' hide BottomSheet;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/l10n/l10n.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/enums/book_format.dart';
import 'package:volume_vault/models/enums/read_status.dart';
import 'package:volume_vault/pages/register_edit_book_page/commands/register_edit_book_page_command.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/edit_book_request.dart';
import 'package:volume_vault/services/models/register_book_request.dart';
import 'package:volume_vault/shared/hooks/text_field_tags_controller_hook.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/widgets/chip/chip_list.dart';
import 'package:volume_vault/shared/widgets/viewers/book_image_viewer.dart';
import 'package:volume_vault/shared/widgets/icon/icon_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterEditBookPage extends HookConsumerWidget {
  final RegisterEditBookPageCommand _command = RegisterEditBookPageCommand();

  ///If this model is not null, the page enter in edit mode.
  ///So when you hit the save button, the book will be updated instead of created.
  final BookModel? editBookModel;

  static final _bookInfoFormKey = GlobalKey<FormState>();
  static final _publisherInfoFormKey = GlobalKey<FormState>();
  static final _aditionalInfoFormKey = GlobalKey<FormState>();

  RegisterEditBookPage({super.key, this.editBookModel});

  void validateAndPop(BuildContext context, GlobalKey<FormState> formKey) {
    bool allGood = formKey.currentState!.validate();
    if (allGood) Navigator.pop(context);
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
    final genreController = useTextfieldTagsController();
    final List<String> genreTags =
        List.from(editBookModel?.genre?.toList() ?? List.empty());
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
                            onTap: () => _command.showImageCoverDialog(
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
                            onTap: () => _command.showBookInfoModal(
                                context, _bookInfoFormKey,
                                titleController: titleController,
                                authorController: authorController,
                                isbnController: isbnController),
                          ),
                          ListTile(
                            leading: const Icon(Icons.business_rounded),
                            title: Text(AppLocalizations.of(context)!
                                .publisherInformationRegisterBookPage),
                            trailing: const Icon(Icons.navigate_next_rounded),
                            onTap: () => _command.showPublisherInfoModal(
                                context, _publisherInfoFormKey,
                                publisherController: publisherController,
                                publishYearController: publishYearController,
                                editionController: editionController),
                          ),
                          ListTile(
                            leading: const Icon(Icons.info_rounded),
                            title: Text(AppLocalizations.of(context)!
                                .aditionalInformationRegisterBookPage),
                            trailing: const Icon(Icons.navigate_next_rounded),
                            onTap: () => _command.showAditionalInfoModal(
                              context,
                              _aditionalInfoFormKey,
                              bookFormat: bookFormatState,
                              buyLinkController: buyLinkController,
                              genreController: genreController,
                              genreTags: genreTags,
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
                          ListTile(
                            leading: const Icon(Icons.calendar_month_rounded),
                            title: Text(AppLocalizations.of(context)!
                                .readStatusRegisterBookPage),
                            trailing: const Icon(Icons.navigate_next_rounded),
                            onTap: () => _command.showGetReadDatesModal(context,
                                readStatus: readState,
                                readStartDay: readStartDay,
                                readEndDay: readEndDay,
                                readStartDayController: readStartDayController,
                                readEndDayController: readEndDayController),
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
                                  genre: genreController.hasTags
                                      ? genreController.getTags!.toSet()
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
                                    await _command.showConfirmEditDialog(context);
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
                                genre: genreController.hasTags
                                    ? genreController.getTags!.toSet()
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
                                createdAt: DateTime.now(),
                                lastModification: DateTime.now(),
                              );

                              int? newBookId =
                                  await bookController.registerBook(newBook);
                              final bool success = newBookId != null;

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
