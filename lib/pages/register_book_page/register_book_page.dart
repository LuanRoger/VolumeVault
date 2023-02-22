import 'package:flutter/material.dart' hide BottomSheet;
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:volume_vault/models/enums/book_format.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/validators/text_field_validator.dart';
import 'package:volume_vault/shared/widgets/book_image_viewer.dart';
import 'package:volume_vault/shared/widgets/bottom_sheet.dart';
import 'package:volume_vault/shared/widgets/chip_list.dart';
import 'package:volume_vault/shared/widgets/dialogs/input_dialog.dart';
import 'package:volume_vault/shared/widgets/icon_text.dart';

class RegisterBookPage extends HookWidget {
  final _bookInfoFormKey = GlobalKey<FormState>();
  final _publisherInfoFormKey = GlobalKey<FormState>();
  final _aditionalInfoFormKey = GlobalKey<FormState>();

  RegisterBookPage({super.key});

  Future _showImageCoverDialog(
      BuildContext context, TextEditingController coverTextController) async {
    await InputDialog(
      controller: coverTextController,
      icon: const Icon(Icons.image),
      title: "Imagem da capa",
      textFieldLabel: const Text("URL"),
      prefixIcon: const Icon(Icons.link_rounded),
    ).show(context);
  }

  Future _showAddTagDialog(
      BuildContext context, TextEditingController tagLabelController) async {
    await InputDialog(
      controller: tagLabelController,
      icon: const Icon(Icons.tag_rounded),
      title: "Adicionar tag",
      textFieldLabel: const Text("Tag"),
    ).show(context);
  }

  void validateAndPop(BuildContext context, GlobalKey<FormState> formKey) {
    bool allGood = formKey.currentState!.validate();
    if (allGood) Navigator.pop(context);
  }

  void _showBookInfoModal(BuildContext context,
      {TextEditingController? titleController,
      TextEditingController? authorController,
      TextEditingController? isbnController}) {
    final isbnInputFormater = MaskTextInputFormatter(
        mask: "###-##-####-###-#", type: MaskAutoCompletionType.eager);

    String titleMemento = titleController?.text ?? "";
    String authorMemento = authorController?.text ?? "";
    String isbnMemento = isbnController?.text ?? "";

    BottomSheet(
      action: (context) => FilledButton(
          onPressed: () => validateAndPop(context, _bookInfoFormKey),
          child: const Text("Salvar")),
      onClose: () {
        titleController?.text = titleMemento;
        authorController?.text = authorMemento;
        isbnController?.text = isbnMemento;
      },
      items: [
        Form(
          key: _bookInfoFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                validator: mandatoryNotEmpty,
                decoration: const InputDecoration(labelText: "Titulo *"),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: authorController,
                validator: mandatoryNotEmpty,
                decoration: const InputDecoration(labelText: "Autor *"),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: isbnController,
                validator: mandatoryNotEmptyExactLenght17,
                decoration: const InputDecoration(labelText: "ISBN *"),
                inputFormatters: [isbnInputFormater],
              ),
            ],
          ),
        ),
      ],
    ).show(context);
  }

  void _showPublisherInfoModal(BuildContext context,
      {TextEditingController? publisherController,
      TextEditingController? publishYearController,
      TextEditingController? editionController}) {
    String publisherMemento = publisherController?.text ?? "";
    String publishYearMemento = publishYearController?.text ?? "";
    String editionMemento = editionController?.text ?? "";

    BottomSheet(
      action: (context) => FilledButton(
          onPressed: () => validateAndPop(context, _publisherInfoFormKey),
          child: const Text("Salvar")),
      onClose: () {
        publisherController?.text = publisherMemento;
        publishYearController?.text = publishYearMemento;
        editionController?.text = editionMemento;
      },
      items: [
        Form(
          key: _publisherInfoFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: publisherController,
                validator: maximumLenght100,
                maxLength: 100,
                maxLines: 1,
                decoration: const InputDecoration(labelText: "Editora"),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: publishYearController,
                validator: greaterThanOrEqualTo1,
                decoration:
                    const InputDecoration(labelText: "Ano de publicação"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: editionController,
                validator: greaterThanOrEqualTo1,
                decoration: const InputDecoration(labelText: "Edição"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
        ),
      ],
    ).show(context);
  }

  void _showAditionalInfoModal(BuildContext context,
      {BookFormat? bookFormat,
      TextEditingController? pageNumbController,
      TextEditingController? genreController,
      TextEditingController? buyLinkController}) {
    String pageNumbMemento = pageNumbController?.text ?? "";
    String genreMemento = genreController?.text ?? "";
    String buyLinkMemento = buyLinkController?.text ?? "";

    BottomSheet(
      action: (context) => FilledButton(
        onPressed: () => validateAndPop(context, _aditionalInfoFormKey),
        child: const Text("Salvar"),
      ),
      onClose: () {
        pageNumbController?.text = pageNumbMemento;
        genreController?.text = genreMemento;
        buyLinkController?.text = buyLinkMemento;
      },
      items: [
        Form(
          key: _aditionalInfoFormKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                value: bookFormat,
                validator: null,
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
                onChanged: (newValue) => bookFormat = newValue,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: pageNumbController,
                validator: greaterThanOrEqualTo1,
                decoration: const InputDecoration(labelText: "N° de páginas"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: genreController,
                validator: maximumLenght50,
                maxLength: 50,
                maxLines: 1,
                decoration: const InputDecoration(labelText: "Genero"),
                enableSuggestions: true,
                autocorrect: true,
                enableIMEPersonalizedLearning: true,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: buyLinkController,
                validator: maximumLenght500,
                decoration: const InputDecoration(labelText: "Link de compra"),
                maxLength: 500,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final coverUrlController = useTextEditingController();

    final titleController = useTextEditingController();
    final authorController = useTextEditingController();
    final isbnController = useTextEditingController();

    final editionController = useTextEditingController();
    final publishYearController = useTextEditingController();
    final publisherController = useTextEditingController();

    final bookFormatState = useState<BookFormat>(BookFormat.HARDCOVER);
    final buyLinkController = useTextEditingController();
    final genreController = useTextEditingController();
    final pageNumbController = useTextEditingController();

    final observationController = useTextEditingController();
    final synopsisController = useTextEditingController();

    final readedState = useState(false);
    final tagLabelsState = useState<Set<String>>({});

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
                    child: BookImageViewer(
                        image: NetworkImage(coverUrlController.text)))),
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
                  onTap: () => _showBookInfoModal(context,
                      titleController: titleController,
                      authorController: authorController,
                      isbnController: isbnController),
                ),
                ListTile(
                  leading: const Icon(Icons.business_rounded),
                  title: const Text("Informações da editora"),
                  trailing: const Icon(Icons.navigate_next_rounded),
                  onTap: () => _showPublisherInfoModal(context,
                      publisherController: publisherController,
                      publishYearController: publishYearController,
                      editionController: editionController),
                ),
                ListTile(
                  leading: const Icon(Icons.info_rounded),
                  title: const Text("Informações adicionais"),
                  trailing: const Icon(Icons.navigate_next_rounded),
                  onTap: () => _showAditionalInfoModal(
                    context,
                    bookFormat: bookFormatState.value,
                    buyLinkController: buyLinkController,
                    genreController: genreController,
                    pageNumbController: pageNumbController,
                  ),
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
                    Switch(
                        value: readedState.value,
                        onChanged: (newValue) => readedState.value = newValue),
                  ],
                ),
                const IconText(
                  icon: Icons.tag_rounded,
                  text: "Tags",
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.tonal(
                    onPressed: () async {
                      TextEditingController tagController =
                          TextEditingController();
                      await _showAddTagDialog(context, tagController);
                      if (tagController.text.isEmpty ||
                          tagLabelsState.value.contains(tagController.text)) {
                        return;
                      }
                      
                      tagLabelsState.value = {
                        ...tagLabelsState.value,
                        tagController.text
                      };

                      tagController.dispose();
                    },
                    child: const Text("Adicionar"),
                  ),
                ),
                ChipList(
                  tagLabelsState.value,
                  onRemove: (value) {
                    Set<String> newLabels = Set.from(tagLabelsState.value);
                    newLabels.remove(value);
                    tagLabelsState.value = newLabels;
                  },
                ),
                ElevatedButton(onPressed: () {}, child: const Text("Confirmar"))
              ],
            )
          ]),
        ),
      ),
    );
  }
}
