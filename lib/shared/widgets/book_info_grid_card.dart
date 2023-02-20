import 'package:flutter/material.dart';
import 'package:volume_vault/models/book_model.dart';

class BookInfoGridCard extends StatelessWidget {
  final BookModel bookModel;
  final void Function() onPressed;

  const BookInfoGridCard(this.bookModel, {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (bookModel.coverLink != null)
                Image.network(
                  bookModel.coverLink!,
                  fit: BoxFit.contain,
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookModel.title,
                          style: Theme.of(context).textTheme.headlineLarge,
                          overflow: TextOverflow.clip,
                        ),
                        Text(
                          "${bookModel.author} - ${bookModel.publicationYear.toString()}",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        if (bookModel.publisher != null)
                          Text(
                            "ed. ${bookModel.publisher!}",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          bookModel.isbn,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        bookModel.pagesNumber != null
                            ? Text("p. ${bookModel.pagesNumber}",
                                style:
                                    Theme.of(context).textTheme.headlineSmall)
                            : const SizedBox(),
                      ],
                    )
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
