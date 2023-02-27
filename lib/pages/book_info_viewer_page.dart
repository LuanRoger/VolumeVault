import 'package:flutter/material.dart';
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
import 'package:volume_vault/shared/widgets/list_tile_text.dart';
import 'package:volume_vault/shared/widgets/title_card.dart';

class BookInfoViewerPage extends ConsumerWidget {
  final BookModel book;

  const BookInfoViewerPage(this.book, {super.key});

  Future<Widget> _buildCoverShowcase(String coverLink,
      {required Size showcaseSize,
      required BuildContext context,
      bool renderLightEffect = true}) async {
    if (coverLink.isEmpty) return const SizedBox();
    NetworkImage coverImage = NetworkImage(coverLink);

    await precacheImage(coverImage, context);
    Color? dominantColor = await ImageUtils.getDominantColor(coverImage);

    return BookShowcase(
        size: showcaseSize, image: coverImage, color: dominantColor, lightEffect: renderLightEffect,);
  }

  void launchBuyPage(String buyPageLink) async {
    await launchUrl(Uri.parse(buyPageLink));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graphicsPreferences = ref.watch(graphicsPreferencesStateProvider);
    final size = MediaQuery.of(context).size;

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
                onPressed: () => launchBuyPage(book.buyLink!),
                icon: const Icon(Icons.shopping_cart_rounded)),
          PopupMenuButton(
              itemBuilder: (_) =>
                  [const PopupMenuItem(value: 0, child: Text("Deletar"))],
              onSelected: (value) {},
              icon: const Icon(Icons.more_vert_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
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
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  book.author,
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
                  label: Text("${book.edition ?? "-"}"),
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
                ListTileText(title: "ISBN", text: book.isbn),
                ListTileText(title: "Editora", text: book.publisher),
                ListTileText(
                    title: "Ano de lançamento",
                    text: book.publicationYear.toString()),
                ListTileText(title: "Formato", text: book.format?.name),
                if (book.readed != null)
                  ListTileText(
                      title: "Lido", text: book.readed! ? "Sim" : "Não"),
                ListTileText(
                    title: "Criado em",
                    text: dayMonthYearFormat.format(book.createdAt)),
                ListTileText(
                    title: "Ultima modificação",
                    text: dayMonthYearFormat.format(book.lastModification)),
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
    );
  }
}
