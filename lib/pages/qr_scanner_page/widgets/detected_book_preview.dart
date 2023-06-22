import 'package:flutter/material.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/shared/widgets/viewers/book_image_viewer.dart';

class DetectedBookPreview extends StatelessWidget {
  final BookModel book;

  const DetectedBookPreview({super.key, required this.book});

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
