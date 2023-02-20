import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/shared/time_formats.dart';
import 'package:volume_vault/shared/widgets/chip_list.dart';
import 'package:volume_vault/shared/widgets/icon_text.dart';
import 'package:volume_vault/shared/widgets/list_tile_text.dart';
import 'package:volume_vault/shared/widgets/radial_light.dart';
import 'package:volume_vault/shared/widgets/title_card.dart';

class BookInfoViewerPage extends StatelessWidget {
  final BookModel book;

  const BookInfoViewerPage(this.book, {super.key});

  Future<Color?> getColorFromImage(ImageProvider image) async {
    try {
      final PaletteGenerator palette =
          await PaletteGenerator.fromImageProvider(image);
      return palette.dominantColor?.color;
    } catch (_) {
      return null;
    }
  }

  Future<Widget> _buildCoverShowcase(String coverLink,
      {required Size screenSize, required BuildContext context}) async {
    if (coverLink.isEmpty) return const SizedBox();
    NetworkImage coverImage = NetworkImage(coverLink);

    await precacheImage(coverImage, context);
    Color? dominantColor = await getColorFromImage(coverImage);

    return Stack(
      alignment: Alignment.center,
      children: [
        if (dominantColor != null)
          Animate(
            effects: const [
              ScaleEffect(
                  duration: Duration(seconds: 1), curve: Curves.easeOutCirc)
            ],
            child: RadialLight(250 * 1.2, screenSize.width,
                radius: 100, colors: [dominantColor]),
          ),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(width: 0.5),
          ),
          height: 250,
          width: 175,
          child: Image(
            image: coverImage,
            fit: BoxFit.scaleDown,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.image_not_supported_rounded),
          ),
        ).animate(effects: const [
          FadeEffect(
              curve: Curves.easeInOutQuart,
              duration: Duration(milliseconds: 500))
        ]),
      ],
    );
  }

  void launchBuyPage(String buyPageLink) async {
    await launchUrl(Uri.parse(buyPageLink));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit_rounded)),
          if (book.buyLink != null)
            IconButton(
                onPressed: () => launchBuyPage(book.buyLink!),
                icon: const Icon(Icons.shopping_cart_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if(book.coverLink != null)
            SizedBox(
                height: 250 * 1.2,
                width: size.width,
                child: FutureBuilder(
                  future: _buildCoverShowcase(book.coverLink!,
                      screenSize: size, context: context),
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
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    book.title,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    book.author,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
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
                children: [
                  const IconText(icon: Icons.tag_rounded, text: "Tags"),
                  const SizedBox(height: 5),
                  ChipList(book.tags!),
                ],
              )
          ]),
        ),
      ),
    );
  }
}
