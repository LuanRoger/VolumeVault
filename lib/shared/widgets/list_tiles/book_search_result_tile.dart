import 'package:flutter/material.dart';
import 'package:volume_vault/models/book_search_result_model.dart';

class BookSearchResultTile extends StatelessWidget {
  final BookSearchResultModel bookSearchResult;
  final void Function()? onTap;

  const BookSearchResultTile(this.bookSearchResult, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.book_rounded),
      title: Text(
        bookSearchResult.title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(bookSearchResult.author),
      autofocus: true,
      trailing: const Text("Ver informações"),
      onTap: onTap,
    );
  }
}
