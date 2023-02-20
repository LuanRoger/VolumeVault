import 'package:flutter/material.dart' hide BottomSheet;
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:volume_vault/models/enums/book_format.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/widgets/book_image_viewer.dart';
import 'package:volume_vault/shared/widgets/bottom_sheet.dart';

class RegisterBookPage extends HookWidget {
  const RegisterBookPage({super.key});

  void _showImageCoverDialog(
      BuildContext context, TextEditingController coverTextController) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              alignment: Alignment.center,
              title: Text(
                "Imagem da capa",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              icon: const Icon(Icons.image),
              content: TextField(
                  controller: coverTextController,
                  decoration: const InputDecoration(
                      label: Text("URL"),
                      filled: true,
                      prefixIcon: Icon(Icons.link_rounded),
                      border: UnderlineInputBorder())),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar")),
                TextButton(onPressed: () {}, child: const Text("Aceitar"))
              ],
            ));
  }

  void _showBookInfoModal(BuildContext context) {
    final isbnInputFormater = MaskTextInputFormatter(
        mask: "###-##-####-###-#", type: MaskAutoCompletionType.eager);

    BottomSheet(
      action: FilledButton(onPressed: () {}, child: const Text("Salvar")),
      items: [
        TextFormField(
          decoration: const InputDecoration(labelText: "Titulo *"),
        ),
        const SizedBox(height: 15),
        TextFormField(
          decoration: const InputDecoration(labelText: "Autor *"),
        ),
        const SizedBox(height: 15),
        TextFormField(
          decoration: const InputDecoration(labelText: "ISBN *"),
          inputFormatters: [isbnInputFormater],
        ),
      ],
    ).show(context);
  }

  void _showPublisherInfoModal(BuildContext context) {
    BottomSheet(
      action: FilledButton(onPressed: () {}, child: const Text("Salvar")),
      items: [
        TextFormField(
          decoration: const InputDecoration(labelText: "Ano de publicação"),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 15),
        TextFormField(
          decoration: const InputDecoration(labelText: "Edição"),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 15),
        TextFormField(
          maxLength: 100,
          maxLines: 1,
          decoration: const InputDecoration(labelText: "Editora"),
        ),
      ],
    ).show(context);
  }

  void _showAditionalInfoModal(BuildContext context) {
    BottomSheet(
      action: FilledButton(onPressed: () {}, child: const Text("Salvar")),
      items: [
        DropdownButtonFormField(
          value: BookFormat.HARDCOVER,
          items: [
            DropdownMenuItem(
              value: BookFormat.HARDCOVER,
              child: Text(BookFormat.HARDCOVER.name),
            ),
            DropdownMenuItem(
              value: BookFormat.HARDBACK,
              child: Text(BookFormat.HARDBACK.name),
            ),
            DropdownMenuItem(
              value: BookFormat.PAPERBACK,
              child: Text(BookFormat.PAPERBACK.name),
            ),
            DropdownMenuItem(
              value: BookFormat.EBOOK,
              child: Text(BookFormat.EBOOK.name),
            )
          ],
          onChanged: (selectedValue) {},
        ),
        const SizedBox(height: 15),
        TextFormField(
          decoration: const InputDecoration(labelText: "N° de páginas"),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 15),
        TextFormField(
          maxLength: 50,
          maxLines: 1,
          decoration: const InputDecoration(labelText: "Genero"),
          enableSuggestions: true,
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
        ),
        const SizedBox(height: 15),
        TextFormField(
          decoration: const InputDecoration(labelText: "Link de compra"),
          maxLength: 500,
          maxLines: 1,
        ),
      ],
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final coverUrlController = useTextEditingController();
    final observationController = useTextEditingController();
    final synopsisController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Align(
                alignment: Alignment.center,
                child: GestureDetector(
                    onTap: () =>
                        _showImageCoverDialog(context, coverUrlController),
                    child: BookImageViewer(image: const NetworkImage("")))),
            const SizedBox(height: 5.0),
            Text(
              "Seções que tem \"*\" possuem campos obrigatorios",
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
                  title: const Text("Informações do livro *"),
                  trailing: const Icon(Icons.navigate_next_rounded),
                  onTap: () => _showBookInfoModal(context),
                ),
                ListTile(
                  leading: const Icon(Icons.business_rounded),
                  title: const Text("Informações da editora"),
                  trailing: const Icon(Icons.navigate_next_rounded),
                  onTap: () => _showPublisherInfoModal(context),
                ),
                ListTile(
                  leading: const Icon(Icons.info_rounded),
                  title: const Text("Informações adicionais"),
                  trailing: const Icon(Icons.navigate_next_rounded),
                  onTap: () => _showPublisherInfoModal(context),
                ),
                ListTile(
                  leading: const Icon(Icons.text_snippet_rounded),
                  title: const Text("Sinopse e observação"),
                  trailing: const Icon(Icons.navigate_next_rounded),
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.largeInfoInputPageRoute,
                      arguments: [observationController, synopsisController]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Lido"),
                    Switch(value: true, onChanged: (newValue) {}),
                  ],
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
