import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:volume_vault/models/enums/book_format.dart';
import 'package:volume_vault/models/enums/read_status.dart';
import 'package:volume_vault/pages/register_edit_book_page/commands/book_info_getter_command.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';

class BookInfoGetter extends StatelessWidget {
  final BookInfoGetterCommand _command;
  final Divider? divider;

  final TextEditingController titleController;
  final TextEditingController authorController;
  final TextEditingController isbnController;
  final TextEditingController publisherController;
  final TextEditingController publishYearController;
  final TextEditingController editionController;
  final TextEditingController buyLinkController;
  final TextfieldTagsController genreController;
  final TextEditingController pageNumbController;
  final TextEditingController observationController;
  final TextEditingController synopsisController;
  final TextEditingController readStartDayController;
  final TextEditingController readEndDayController;
  final DateTime? readStartDay;
  final DateTime? readEndDay;

  final ReadStatus readStatus;

  final GlobalKey<FormState> _bookInfoFormKey;
  final GlobalKey<FormState> _publisherInfoFormKey;
  final GlobalKey<FormState> _aditionalInfoFormKey;

  final BookFormat bookFormat;

  const BookInfoGetter({
    super.key,
    required BookInfoGetterCommand command,
    this.divider,
    required this.titleController,
    required this.authorController,
    required this.isbnController,
    required this.publisherController,
    required this.publishYearController,
    required this.editionController,
    required this.buyLinkController,
    required this.genreController,
    required this.pageNumbController,
    required this.observationController,
    required this.synopsisController,
    required this.readStartDayController,
    required this.readEndDayController,
    this.readStartDay,
    this.readEndDay,
    required this.readStatus,
    required GlobalKey<FormState> bookInfoFormKey,
    required GlobalKey<FormState> publisherInfoFormKey,
    required GlobalKey<FormState> aditionalInfoFormKey,
    required this.bookFormat,
  })  : _command = command,
        _bookInfoFormKey = bookInfoFormKey,
        _publisherInfoFormKey = publisherInfoFormKey,
        _aditionalInfoFormKey = aditionalInfoFormKey;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ListTile(
          leading: const Icon(Icons.book_rounded),
          title: Text(
              AppLocalizations.of(context)!.bookInformationRegisterBookPage),
          trailing: const Icon(Icons.navigate_next_rounded),
          onTap: () => _command.showBookInfoModal(context, _bookInfoFormKey,
              titleController: titleController,
              authorController: authorController,
              isbnController: isbnController),
        ),
        if (divider != null) divider!,
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
        if (divider != null) divider!,
        ListTile(
          leading: const Icon(Icons.info_rounded),
          title: Text(AppLocalizations.of(context)!
              .aditionalInformationRegisterBookPage),
          trailing: const Icon(Icons.navigate_next_rounded),
          onTap: () => _command.showAditionalInfoModal(
            context,
            _aditionalInfoFormKey,
            bookFormat: bookFormat,
            buyLinkController: buyLinkController,
            genreController: genreController,
            pageNumbController: pageNumbController,
          ),
        ),
        if (divider != null) divider!,
        ListTile(
            leading: const Icon(Icons.text_snippet_rounded),
            title: Text(AppLocalizations.of(context)!
                .synopsisAndObservationsRegisterBookPage),
            trailing: const Icon(Icons.navigate_next_rounded),
            onTap: () async {
              final List<String>? observationSynopsisValue = await context.push(
                  AppRoutes.largeInfoInputPageRoute,
                  extra: [observationController.text, synopsisController.text]);
              if (observationSynopsisValue == null ||
                  observationSynopsisValue.length != 2) {
                return;
              }

              observationController.text = observationSynopsisValue[0];
              synopsisController.text = observationSynopsisValue[1];
            }),
        if (divider != null) divider!,
        ListTile(
          leading: const Icon(Icons.calendar_month_rounded),
          title: Text(AppLocalizations.of(context)!.readStatusRegisterBookPage),
          trailing: const Icon(Icons.navigate_next_rounded),
          onTap: () => _command.showGetReadDatesModal(context,
              readStatus: readStatus,
              readStartDay: readStartDay,
              readEndDay: readEndDay,
              readStartDayController: readStartDayController,
              readEndDayController: readEndDayController),
        ),
      ],
    );
  }
}
