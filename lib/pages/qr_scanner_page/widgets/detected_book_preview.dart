import "package:flutter/material.dart";
import "package:volume_vault/models/book_model.dart";
import "package:volume_vault/models/enums/qr_scanner_result_type.dart";
import "package:volume_vault/models/qr_share_recive.dart";
import "package:volume_vault/shared/widgets/viewers/book_image_viewer.dart";

class QrDetectedInfoPreview extends StatelessWidget {
  final QrShareRecive qrShare;

  const QrDetectedInfoPreview({required this.qrShare, super.key});

  @override
  Widget build(BuildContext context) {
    if (qrShare.recivedInfo == null) return const SizedBox();

    return switch (qrShare.resultType) {
      QrScannerResultType.book =>
        _QrDetectedBookPreview(book: qrShare.getBookModel!),
      QrScannerResultType.collection ||
      QrScannerResultType.text =>
        const SizedBox()
    };
  }
}

class _QrDetectedBookPreview extends StatelessWidget {
  final BookModel book;

  const _QrDetectedBookPreview({required this.book});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (book.coverLink != null)
          BookImageViewer(image: NetworkImage(book.coverLink!)),
        Text(book.title, style: Theme.of(context).textTheme.headlineLarge),
        Text(book.author, style: Theme.of(context).textTheme.titleMedium)
      ],
    );
  }
}
