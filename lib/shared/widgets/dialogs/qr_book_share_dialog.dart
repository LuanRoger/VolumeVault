import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/shared/widgets/dialogs/content_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrBookShareDialog {
  final BookModel book;

  QrBookShareDialog({required this.book});

  String _convertToBase64() {
    final String jsonBook = json.encode(book);
    final String base64Book = base64.encode(utf8.encode(jsonBook));

    return base64Book;
  }

  Future<void> show(BuildContext context) async {
    final String base64Book = _convertToBase64();

    ContentDialog dialog = ContentDialog(
      heightFactor: 0.6,
      widthFactor: 0.4,
      padding: const EdgeInsets.all(8.0),
      content: Column(
        children: [
          Text(
            book.title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          Text(
            book.author,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: QrImageView(
              data: base64Book,
              size: 280,
            ),
          ),
          
        ],
      ),
    );

    await dialog.show(context);
  }
}
