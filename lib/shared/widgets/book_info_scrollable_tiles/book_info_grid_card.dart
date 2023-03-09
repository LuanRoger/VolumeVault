import 'package:flutter/material.dart';
import 'package:volume_vault/shared/widgets/book_image_viewer.dart';
import 'package:volume_vault/shared/widgets/book_info_scrollable_tiles/book_info_card.dart';

class BookInfoGridCard extends BookInfoCard {
  const BookInfoGridCard(super.bookModel,
      {super.key, required super.onPressed});

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
                Expanded(
                  flex: 0,
                  child: BookImageViewer(
                    image: NetworkImage(bookModel.coverLink!),
                    sizeMultiplier: 1.2,
                    border: Border.all(width: 0.0),
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              Flexible(
                flex: 0,
                child: Padding(
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
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                          ),
                          Text(
                            bookModel.publicationYear == null
                                ? bookModel.author
                                : "${bookModel.author} - ${bookModel.publicationYear.toString()}",
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
