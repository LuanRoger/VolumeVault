import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class BookInfoViewerStrategy {
  const BookInfoViewerStrategy();

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

  void launchBuyPage(String buyPageLink) async {
    await launchUrl(Uri.parse(buyPageLink));
  }
}
