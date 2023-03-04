import 'package:flutter/material.dart' hide BottomSheet;
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/enums/book_format.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/edit_book_request.dart';
import 'package:volume_vault/services/models/register_book_request.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/validators/text_field_validator.dart';
import 'package:volume_vault/shared/widgets/book_image_viewer.dart';
import 'package:volume_vault/shared/widgets/bottom_sheet.dart';
import 'package:volume_vault/shared/widgets/chip_list.dart';
import 'package:volume_vault/shared/widgets/dialogs/input_dialog.dart';
import 'package:volume_vault/shared/widgets/icon_text.dart';

class RegisterEditBookPage extends HookConsumerWidget {
  ///If this model is not null, the page enter in edit mode.
  ///So when you hit the save button, the book will be updated instead of created.
  final BookModel? editBookModel;

  final _bookInfoFormKey = GlobalKey<FormState>();
  final _publisherInfoFormKey = GlobalKey<FormState>();
  final _aditionalInfoFormKey = GlobalKey<FormState>();

  RegisterEditBookPage({super.key, this.editBookModel});

  Future<bool> _registerNewBook(WidgetRef ref,
      {required RegisterBookRequest book}) async {
    final bookService = await ref.read(bookServiceProvider.future);
    if (bookService == null) return false;

    final BookModel? registeredBook = await bookService.registerBook(book);

    return registeredBook != null;
  }

  Future<bool> _updateBook(WidgetRef ref,
      {required EditBookRequest newInfosBook, required int bookId}) async {
    final bookService = await ref.read(bookServiceProvider.future);
    if (bookService == null) return false;

    final updatedBook = await bookService.updateBook(bookId, newInfosBook);

    return updatedBook;
  }

  Future<bool> _showConfirmEditDialog(BuildContext context) async {
    bool saveUpdates = false;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar livro"),
        content: const Text("Deseja salvar as alterações?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Não"),
          ),
          TextButton(
            onPressed: () {
              saveUpdates = true;
              Navigator.pop(context, true);
            },
            child: const Text("Sim"),
          ),
        ],
      ),
    );

    return saveUpdates;
  }

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
                keyboardType: TextInputType.number,
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
                style: Theme.of(context).textTheme.bodyMedium,
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
  Widget build(BuildContext context, WidgetRef ref) {
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
        useState<BookFormat>(editBookModel?.format ?? BookFormat.HARDCOVER);
    final buyLinkController =
        useTextEditingController(text: editBookModel?.buyLink);
    final genreController =
        useTextEditingController(text: editBookModel?.genre);
    final pageNumbController =
        useTextEditingController(text: editBookModel?.pagesNumber?.toString());

    final observationController =
        useTextEditingController(text: editBookModel?.observation);
    final synopsisController =
        useTextEditingController(text: editBookModel?.synopsis);

    final readedState = useState(false);
    final tagLabelsState = useState<Set<String>>(editBookModel?.tags ?? {});
    final editMode = editBookModel != null;

    final loadingState = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: Text(!editMode ? "Novo livro" : "Editar livro"),
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
                            onTap: () => _showImageCoverDialog(
                                context, coverUrlController),
                            child: BookImageViewer(
                              image: NetworkImage(coverUrlController.text),
                            ),
                          )),
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
                                arguments: [
                                  observationController,
                                  synopsisController
                                ]),
                          ),
                          ListTile(
                            title: const Text("Lido"),
                            trailing: Switch(
                                value: readedState.value,
                                onChanged: (newValue) =>
                                    readedState.value = newValue),
                            onTap: () => readedState.value = !readedState.value,
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
                              child: const Text("Adicionar"),
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
                                    publicationYear: int.tryParse(
                                        publishYearController.text),
                                    publisher:
                                        publisherController.text.isNotEmpty
                                            ? publisherController.text
                                            : null,
                                    edition:
                                        int.tryParse(editionController.text),
                                    pagesNumber:
                                        int.tryParse(pageNumbController.text),
                                    genre: genreController.text.isNotEmpty
                                        ? genreController.text
                                        : null,
                                    format: bookFormatState.value.index,
                                    observation:
                                        observationController.text.isNotEmpty
                                            ? observationController.text
                                            : null,
                                    synopsis: synopsisController.text.isNotEmpty
                                        ? synopsisController.text
                                        : null,
                                    coverLink:
                                        coverUrlController.text.isNotEmpty
                                            ? coverUrlController.text
                                            : null,
                                    buyLink: buyLinkController.text.isNotEmpty
                                        ? buyLinkController.text
                                        : null,
                                    readed: readedState.value,
                                    tags: tagLabelsState.value.isNotEmpty
                                        ? tagLabelsState.value
                                        : null,
                                    lastModification: DateTime.now().toUtc(),
                                  );
                                  final bool saveInfos =
                                      await _showConfirmEditDialog(context);
                                  if (!saveInfos) return;

                                  final updateResult = await _updateBook(ref,
                                      newInfosBook: updatedBook,
                                      bookId: editBookModel!.id);
                                  if (!updateResult) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Não foi possível atualizar o livro"),
                                      ),
                                    );
                                    return;
                                  }

                                  Navigator.pop(context);
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
                                  genre: genreController.text.isNotEmpty
                                      ? genreController.text
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
                                  readed: readedState.value,
                                  tags: tagLabelsState.value.isNotEmpty
                                      ? tagLabelsState.value
                                      : null,
                                  coverLink: coverUrlController.text.isNotEmpty
                                      ? coverUrlController.text
                                      : null,
                                  buyLink: buyLinkController.text.isNotEmpty
                                      ? buyLinkController.text
                                      : null,
                                  createdAt: DateTime.now().toUtc(),
                                  lastModification: DateTime.now().toUtc(),
                                );

                                final bool success =
                                    await _registerNewBook(ref, book: newBook);
                                if (success) {
                                  Navigator.pop(context);
                                  return;
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Erro ao registrar livro"),
                                  ),
                                );
                                loadingState.value = false;
                              },
                              child: const Text("Confirmar"))
                        ],
                      )
                    ]),
              ),
      ),
    );
  }
}
