// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:text_scroll/text_scroll.dart";
import 'package:volume_vault/l10n/l10n.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/pages/book_info_view/commands/book_info_viewer_command.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import "package:volume_vault/shared/theme/text_themes.dart";
import 'package:volume_vault/shared/time_formats.dart';
import 'package:volume_vault/shared/utils/image_utils.dart';
import 'package:volume_vault/shared/widgets/cards/title_card.dart';
import 'package:volume_vault/shared/widgets/cards/title_text_card.dart';
import 'package:volume_vault/shared/widgets/chip/chip_list.dart';
import 'package:volume_vault/shared/widgets/icon/icon_text.dart';
import 'package:volume_vault/shared/widgets/progress_indicators/read_progress.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:volume_vault/shared/widgets/viewers/book_showcase.dart';

class BookInfoViewerPage extends HookConsumerWidget {
  final BookModel _book;
  final Future<void> Function(String, BuildContext)? onCardPressed;

  final BookInfoViewerCommand _command = const BookInfoViewerCommand();

  const BookInfoViewerPage(this._book, {super.key, this.onCardPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMounted = useIsMounted();
    final currentBookInfoState = useState(_book);
    final hasChanges = useState(false);
    final book = currentBookInfoState.value;

    final isLoadingState = useState(false);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, hasChanges.value)),
          actions: [
            IconButton(
              onPressed: () async {
                final bool? success = await context.push<bool>(
                    AppRoutes.registerEditBookPageRoute,
                    extra: [book, true]);
                if (success == null || !success || !isMounted()) return;

                final BookModel? newInfoBook =
                    await _command.refreshBookInfo(context, ref, book.id);
                if (newInfoBook == null) return;

                currentBookInfoState.value = newInfoBook;
                hasChanges.value = true;
              },
              icon: const Icon(Icons.edit_rounded),
            ),
            if (book.buyLink != null)
              IconButton(
                onPressed: () => _command.launchBuyPage(book.buyLink!),
                icon: const Icon(Icons.shopping_cart_rounded),
              ),
            IconButton(
              onPressed: () async {
                await _command.showBookShareQrCode(context, bookModel: book);
              },
              icon: const Icon(Icons.share_rounded),
            ),
            IconButton(
              onPressed: () async {
                bool delete = await _command.showDeleteBookDialog(context);
                if (!delete || !isMounted()) return;
                isLoadingState.value = true;

                final bool success =
                    await _command.deleteBook(context, ref, book.id);
                if (!success) return;

                Navigator.pop(context, true);
                isLoadingState.value = false;
              },
              icon: const Icon(Icons.delete_rounded),
            )
          ],
        ),
        body: isLoadingState.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : BookInfoViwerBodyPage(
                book,
                onCardPressed: onCardPressed,
                onRefresh: () async {
                  final BookModel? newInfoBook =
                      await _command.refreshBookInfo(context, ref, book.id);
                  if (newInfoBook == null) return;

                  currentBookInfoState.value = newInfoBook;
                },
              ));
  }
}

class BookInfoViwerBodyPage extends HookConsumerWidget {
  final BookModel book;
  final Future<void> Function() onRefresh;
  final Future<void> Function(String, BuildContext)? onCardPressed;

  const BookInfoViwerBodyPage(this.book,
      {super.key, required this.onRefresh, this.onCardPressed});

  Future<Widget> _buildCoverShowcase(String coverLink,
      {required Size showcaseSize,
      required BuildContext context,
      bool renderLightEffect = true}) async {
    if (coverLink.isEmpty) return const SizedBox();
    NetworkImage coverImage = NetworkImage(coverLink);

    await precacheImage(coverImage, context);
    Color? dominantColor = await ImageUtils.getDominantColor(coverImage);

    return BookShowcase(
      size: showcaseSize,
      image: coverImage,
      color: dominantColor,
      lightEffect: renderLightEffect,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graphicsPreferences = ref.watch(graphicsPreferencesStateProvider);
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(children: [
          if (book.coverLink != null)
            SizedBox(
                height: 250 * 1.2,
                width: size.width,
                child: FutureBuilder(
                  future: _buildCoverShowcase(book.coverLink!,
                      showcaseSize: Size(size.width, 250 * 1.2),
                      context: context,
                      renderLightEffect: graphicsPreferences.lightEffect),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return const SizedBox();
                    }

                    return snapshot.data!;
                  },
                )),
          Column(
            children: [
              TextScroll(
                book.title,
                mode: TextScrollMode.bouncing,
                pauseBetween: const Duration(seconds: 1),
                velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                fadedBorder: true,
                pauseOnBounce: const Duration(seconds: 2),
                fadedBorderWidth: 0.01,
                delayBefore: const Duration(seconds: 2),
                textAlign: TextAlign.center,
                style: headlineSmall.copyWith(fontWeight: FontWeight.bold),
              ),
              TextScroll(
                book.author,
                mode: TextScrollMode.bouncing,
                pauseBetween: const Duration(seconds: 1),
                velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                fadedBorder: true,
                pauseOnBounce: const Duration(seconds: 2),
                fadedBorderWidth: 0.01,
                delayBefore: const Duration(seconds: 2),
                textAlign: TextAlign.center,
                style: titleMedium.copyWith(fontSize: 25),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Chip(
                avatar: const Icon(Icons.numbers_rounded),
                label: Text(book.edition != null ? "Ed. ${book.edition}" : "-"),
              ),
              Chip(
                avatar: const Icon(Icons.insert_drive_file_rounded),
                label: Text("${book.pagesNumber ?? "-"}"),
              )
            ],
          ),
          const SizedBox(height: 5),
          if (book.synopsis != null)
            TitleTextCard(
              title: AppLocalizations.of(context)!.synopsisBookViewerPage,
              content: book.synopsis!,
              expand: true,
            ),
          const SizedBox(height: 5),
          IconText(
              icon: Icons.menu_book_rounded,
              text: AppLocalizations.of(context)!.informationsBookViewerPage),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ListTile(
                  title: Text(AppLocalizations.of(context)!.isbnBookViewerPage),
                  trailing: Text(book.isbn)),
              if (book.publisher != null)
                ListTile(
                    title: Text(
                        AppLocalizations.of(context)!.publisherBookViewerPage),
                    trailing: Text(book.publisher!)),
              if (book.publicationYear != null)
                ListTile(
                    title: Text(AppLocalizations.of(context)!
                        .releaseYearBookViewerPage),
                    trailing: Text(book.publicationYear.toString())),
              if (book.format != null)
                ListTile(
                    title: Text(
                        AppLocalizations.of(context)!.formatBookViewerPage),
                    trailing:
                        Text(L10n.bookFormat(context, format: book.format!))),
              ListTile(
                title:
                    Text(AppLocalizations.of(context)!.createdAtBookViewerPage),
                trailing: Text(
                  dayMonthYearFormat.format(book.createdAt),
                ),
              ),
              ListTile(
                title: Text(
                    AppLocalizations.of(context)!.lastUpdateBookViewerPage),
                trailing: Text(
                  dayMonthYearFormat.format(book.lastModification),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          if (book.readStatus != null)
            TitleCard(
              title: Text(
                  AppLocalizations.of(context)!.readProgressBookViewerPage),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReadProgress(
                  readStatus: book.readStatus!,
                  readStartDay: book.readStartDay,
                  readEndDay: book.readEndDay,
                ),
              ),
            ),
          const SizedBox(height: 5),
          if (book.observation != null)
            TitleTextCard(
              title: AppLocalizations.of(context)!.observationsBookViewerPage,
              content: book.observation!,
              expand: true,
            ),
          const SizedBox(height: 5),
          if (book.genre != null && book.genre!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconText(
                    icon: Icons.read_more_rounded,
                    text: AppLocalizations.of(context)!.genresBookViewerPage),
                const SizedBox(height: 5),
                ChipList(book.genre!.toSet(),
                    onPressed: (name) => onCardPressed?.call(name, context)),
              ],
            ),
          const SizedBox(height: 5),
          if (book.tags != null && book.tags!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconText(
                    icon: Icons.tag_rounded,
                    text: AppLocalizations.of(context)!.tagsBookViewerPage),
                const SizedBox(height: 5),
                ChipList(book.tags!.toSet(),
                    onPressed: (name) => onCardPressed?.call(name, context))
              ],
            ),
        ]),
      ),
    );
  }
}
