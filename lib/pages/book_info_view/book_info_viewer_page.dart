// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/pages/book_info_view/commands/book_info_viewer_command.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/time_formats.dart';
import 'package:volume_vault/shared/utils/image_utils.dart';
import 'package:volume_vault/shared/widgets/book_showcase.dart';
import 'package:volume_vault/shared/widgets/chip_list.dart';
import 'package:volume_vault/shared/widgets/icon_text.dart';
import 'package:volume_vault/shared/widgets/title_card.dart';

class BookInfoViewerPage extends HookConsumerWidget {
  final BookModel _book;

  final BookInfoViewerCommand _command = const BookInfoViewerCommand();

  const BookInfoViewerPage(this._book, {super.key});

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
                  final bool? success = await Navigator.pushNamed<bool>(
                      context, AppRoutes.registerEditBookPageRoute,
                      arguments: [book]);
                  if (success == null || !success || !isMounted()) return;

                  final BookModel? newInfoBook =
                      await _command.refreshBookInfo(context, ref, book.id);
                  if (newInfoBook == null) return;

                  currentBookInfoState.value = newInfoBook;
                  hasChanges.value = true;
                },
                icon: const Icon(Icons.edit_rounded)),
            if (book.buyLink != null)
              IconButton(
                  onPressed: () => _command.launchBuyPage(book.buyLink!),
                  icon: const Icon(Icons.shopping_cart_rounded)),
            PopupMenuButton(
              itemBuilder: (_) =>
                  [const PopupMenuItem(value: 0, child: Text("Deletar"))],
              onSelected: (value) async {
                switch (value) {
                  case 0:
                    bool delete = await _command.showDeleteBookDialog(context);
                    if (!delete || !isMounted()) break;
                    isLoadingState.value = true;

                    final bool success =
                        await _command.deleteBook(context, ref, book.id);
                    if (!success) break;

                    Navigator.pop(context, true);
                }
                isLoadingState.value = false;
              },
              icon: const Icon(Icons.more_vert_rounded),
            )
          ],
        ),
        body: isLoadingState.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : BookInfoViwerBodyPage(
                book,
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

  const BookInfoViwerBodyPage(this.book, {super.key, required this.onRefresh});

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                book.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                book.author,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                avatar: const Icon(Icons.numbers_rounded),
                label:
                    Text(book.edition != null ? "Ed. ${book.edition}" : "-"),
              ),
              Chip(
                avatar: const Icon(Icons.insert_drive_file_rounded),
                label: Text("${book.pagesNumber ?? "-"}"),
              ),
              Chip(
                avatar: const Icon(Icons.label_rounded),
                label: Text(book.genre ?? "-"),
              )
            ],
          ),
          const SizedBox(height: 5),
          if (book.synopsis != null)
            TitleCard(
              title: "Sinopse",
              content: book.synopsis!,
              expand: true,
            ),
          const SizedBox(height: 5),
          const IconText(icon: Icons.menu_book_rounded, text: "Informações"),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ListTile(title: const Text("ISBN"), trailing: Text(book.isbn)),
              if (book.publisher != null)
                ListTile(
                    title: const Text("Editora"),
                    trailing: Text(book.publisher!)),
              if (book.publicationYear != null)
                ListTile(
                    title: const Text("Ano de lançamento"),
                    trailing: Text(book.publicationYear.toString())),
              if (book.format != null)
                ListTile(
                    title: const Text("Formato"),
                    trailing: Text(book.format!.name)),
              if (book.readed != null)
                ListTile(
                    title: const Text("Lido"),
                    trailing:
                        book.readed! ? const Text("Sim") : const Text("Não")),
              ListTile(
                title: const Text("Criado em"),
                trailing: Text(
                  dayMonthYearFormat.format(book.createdAt),
                ),
              ),
              ListTile(
                title: const Text("Ultima modificação"),
                trailing: Text(
                  dayMonthYearFormat.format(book.lastModification),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          if (book.observation != null)
            TitleCard(
              title: "Obsevação",
              content: book.observation!,
              expand: true,
            ),
          const SizedBox(height: 5),
          if (book.tags != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const IconText(icon: Icons.tag_rounded, text: "Tags"),
                const SizedBox(height: 5),
                ChipList(book.tags!.toSet()),
              ],
            )
        ]),
      ),
    );
  }
}
