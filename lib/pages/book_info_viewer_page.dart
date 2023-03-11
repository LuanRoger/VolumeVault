import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:volume_vault/models/book_model.dart';
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

  const BookInfoViewerPage(this._book, {super.key});

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

  Future<BookModel?> _updateBookInfo(WidgetRef ref, int bookId) async {
    final bookService = await ref.read(bookServiceProvider.future);
    if (bookService == null) return null;

    return bookService.getUserBookById(bookId);
  }

  Future<bool> _showDeleteBookDialog(BuildContext context) async {
    bool delete = false;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Deletar livro"),
        content: const Text("Tem certeza que deseja deletar este livro?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          FilledButton(
            onPressed: () {
              delete = true;
              Navigator.pop(context);
            },
            child: const Text("Deletar"),
          ),
        ],
      ),
    );

    return delete;
  }

  void _launchBuyPage(String buyPageLink) async {
    await launchUrl(Uri.parse(buyPageLink));
  }

  //Return the dialog result and operation result
  Future<bool> _deleteBook(BuildContext context, WidgetRef ref,
      {required int bookId}) async {
    final bookService = await ref.read(bookServiceProvider.future);
    if (bookService == null) return false;

    return await bookService.deleteBook(bookId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graphicsPreferences = ref.watch(graphicsPreferencesStateProvider);
    final size = MediaQuery.of(context).size;

    final loadingState = useState(false);
    final currentBookInfoState = useState(_book);
    final book = currentBookInfoState.value;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(
                  context, AppRoutes.registerEditBookPageRoute,
                  arguments: [book]),
              icon: const Icon(Icons.edit_rounded)),
          if (book.buyLink != null)
            IconButton(
                onPressed: () => _launchBuyPage(book.buyLink!),
                icon: const Icon(Icons.shopping_cart_rounded)),
          PopupMenuButton(
              itemBuilder: (_) =>
                  [const PopupMenuItem(value: 0, child: Text("Deletar"))],
              onSelected: (value) async {
                switch (value) {
                  case 0:
                    bool delete = await _showDeleteBookDialog(context);
                    if (!delete) break;
                    loadingState.value = true;

                    final result =
                        await _deleteBook(context, ref, bookId: book.id);
                    if (!result) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Erro ao deletar livro"),
                        ),
                      );
                    } else {
                      Navigator.pop(context, true);
                    }
                    break;
                }
                loadingState.value = false;
              },
              icon: const Icon(Icons.more_vert_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: loadingState.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  final BookModel? newInfos =
                      await _updateBookInfo(ref, book.id);
                  if (newInfos == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Erro ao atualizar informações"),
                      ),
                    );
                    return;
                  }

                  currentBookInfoState.value = newInfos;
                },
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
                                renderLightEffect:
                                    graphicsPreferences.lightEffect),
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
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
                          label: Text(book.edition != null ? "Ed. ${book.edition}" : "-"),
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
                    const IconText(
                        icon: Icons.menu_book_rounded, text: "Informações"),
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ListTile(
                            title: const Text("ISBN"),
                            trailing: Text(book.isbn)),
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
                              trailing: book.readed!
                                  ? const Text("Sim")
                                  : const Text("Não")),
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
              ),
      ),
    );
  }
}
