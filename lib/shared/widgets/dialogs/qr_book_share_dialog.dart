import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:volume_vault/models/book_model.dart';
import "package:volume_vault/models/qr_share.dart";
import 'package:volume_vault/shared/widgets/dialogs/content_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrBookShareDialog {
  final QrShare shareInfo;
  final String? title;
  final String? subtitle;

  QrBookShareDialog({required this.shareInfo, this.title, this.subtitle});

  String _convertToBase64() {
    final jsonBook = json.encode(shareInfo);
    final base64Book = base64.encode(utf8.encode(jsonBook));

    return base64Book;
  }

  Future<void> show(BuildContext context) async {
    final base64Book = _convertToBase64();

    final dialog = ContentDialog(
      heightFactor: 0.6,
      widthFactor: 0.5,
      padding: EdgeInsets.zero,
      alignment: Alignment.topCenter,
      content: Column(
        children: [
          if (title != null)
            Text(
              title!,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          QrImageView(
            data: base64Book,
            size: 250,
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );

    await dialog.show(context);
  }
}
