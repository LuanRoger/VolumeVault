import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:volume_vault/controllers/book_controller.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/enums/book_format.dart';
import 'package:volume_vault/models/enums/read_status.dart';
import 'package:volume_vault/services/models/edit_book_request.dart';
import 'package:volume_vault/services/models/register_book_request.dart';
import 'package:volume_vault/shared/widgets/dialogs/input_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class RegisterEditBookPageStrategy {
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

  Future<bool> editBook({
    required BookModel editBookModel,
    required BookController bookController,
    required TextEditingController titleController,
    required TextEditingController authorController,
    required TextEditingController isbnController,
    required TextEditingController publisherController,
    required TextEditingController publishYearController,
    required TextEditingController editionController,
    required TextEditingController pageNumbController,
    required TextfieldTagsController genreController,
    required BookFormat bookFormat,
    required TextEditingController observationController,
    required TextEditingController synopsisController,
    required TextEditingController coverUrlController,
    required TextEditingController buyLinkController,
    required ReadStatus readState,
    required DateTime? readStartDay,
    required DateTime? readEndDay,
    required Set<String> tagLabels,
  }) async {
    final updatedBook = EditBookRequest(
      title: titleController.text.isNotEmpty ? titleController.text : null,
      author: authorController.text.isNotEmpty ? authorController.text : null,
      isbn: isbnController.text.isNotEmpty ? isbnController.text : null,
      publicationYear: int.tryParse(publishYearController.text),
      publisher:
          publisherController.text.isNotEmpty ? publisherController.text : null,
      edition: int.tryParse(editionController.text),
      pagesNumber: int.tryParse(pageNumbController.text),
      genre: genreController.getTags!.toSet(),
      format: bookFormat.index,
      observation: observationController.text.isNotEmpty
          ? observationController.text
          : null,
      synopsis:
          synopsisController.text.isNotEmpty ? synopsisController.text : null,
      coverLink:
          coverUrlController.text.isNotEmpty ? coverUrlController.text : null,
      buyLink:
          buyLinkController.text.isNotEmpty ? buyLinkController.text : null,
      readStatus: readState,
      readStartDay:
          readState == ReadStatus.reading || readState == ReadStatus.hasRead
              ? readStartDay?.toUtc()
              : null,
      readEndDay: readState == ReadStatus.hasRead ? readEndDay?.toUtc() : null,
      tags: tagLabels.isNotEmpty ? tagLabels : null,
      lastModification: DateTime.now().toUtc(),
    );

    final updateResult =
        await bookController.updateBookInfo(editBookModel.id, updatedBook);
    return updateResult;
  }

  Future<bool> registerBook({
    required BookController bookController,
    required TextEditingController titleController,
    required TextEditingController authorController,
    required TextEditingController isbnController,
    required TextEditingController publisherController,
    required TextEditingController publishYearController,
    required TextEditingController editionController,
    required TextEditingController pageNumbController,
    required TextfieldTagsController genreController,
    required BookFormat bookFormat,
    required TextEditingController observationController,
    required TextEditingController synopsisController,
    required TextEditingController coverUrlController,
    required TextEditingController buyLinkController,
    required ReadStatus readState,
    required DateTime? readStartDay,
    required DateTime? readEndDay,
    required Set<String> tagLabels,
  }) async {
    final newBook = RegisterBookRequest(
      title: titleController.text,
      author: authorController.text,
      isbn: isbnController.text,
      publisher:
          publisherController.text.isNotEmpty ? publisherController.text : null,
      publicationYear: int.tryParse(publishYearController.text),
      edition: int.tryParse(editionController.text),
      format: bookFormat.index,
      genre: genreController.hasTags ? genreController.getTags!.toSet() : null,
      pagesNumber: int.tryParse(pageNumbController.text),
      observation: observationController.text.isNotEmpty
          ? observationController.text
          : null,
      synopsis:
          synopsisController.text.isNotEmpty ? synopsisController.text : null,
      readStatus: readState,
      readStartDay:
          readState == ReadStatus.reading || readState == ReadStatus.hasRead
              ? readStartDay
              : null,
      readEndDay: readState == ReadStatus.hasRead ? readEndDay : null,
      tags: tagLabels.isNotEmpty ? tagLabels : null,
      coverLink:
          coverUrlController.text.isNotEmpty ? coverUrlController.text : null,
      buyLink:
          buyLinkController.text.isNotEmpty ? buyLinkController.text : null,
      createdAt: DateTime.now(),
      lastModification: DateTime.now(),
    );

    final newBookId = await bookController.registerBook(newBook);
    return newBookId != null;
  }
}
