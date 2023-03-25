import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/providers/providers.dart';

abstract class BookInfoViewerStrategy {
  const BookInfoViewerStrategy();

  Future<BookModel?> refreshBookInfo(
      BuildContext context, WidgetRef ref, int bookId) async {
    final bookController = await ref.read(bookControllerProvider.future);
    final BookModel? newBookInfo = await bookController.getBookInfoById(bookId);

    if (newBookInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao atualizar informações"),
        ),
      );
    }

    return newBookInfo;
  }

  Future<bool> showDeleteBookDialog(BuildContext context) async {
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

  Future<bool> deleteBook(
      BuildContext context, WidgetRef ref, int bookId) async {
    final controller = await ref.read(bookControllerProvider.future);
    final result = await controller.deleteBook(bookId);

    if (!result && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao deletar livro"),
        ),
      );
    }

    return result;
  }

  void launchBuyPage(String buyPageLink) async {
    await launchUrl(Uri.parse(buyPageLink));
  }
}
