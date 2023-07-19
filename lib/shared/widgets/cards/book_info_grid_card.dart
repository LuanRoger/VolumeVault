import 'package:flutter/material.dart';
import "package:volume_vault/shared/theme/text_themes.dart";
import 'package:volume_vault/shared/widgets/viewers/book_image_viewer.dart';
import 'package:volume_vault/shared/widgets/cards/book_info_card.dart';

class BookInfoGridCard extends BookInfoCard {
  const BookInfoGridCard(super.bookModel,
      {required super.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            flex: 0,
            child: BookImageViewer(
              image: bookModel.coverLink != null
                  ? NetworkImage(bookModel.coverLink!)
                  : null,
              border: Border.all(width: 0),
              borderRadius: BorderRadius.zero,
              fit: BoxFit.fitWidth,
            ),
          ),
          Flexible(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookModel.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: titleLarge.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        bookModel.publicationYear == null
                            ? bookModel.author
                            : "${bookModel.author} - "
                                "${bookModel.publicationYear}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: titleSmall,
                      ),
                      if (bookModel.synopsis != null)
                        ...(() => [
                              const Divider(),
                              Text(bookModel.synopsis!,
                                  overflow: TextOverflow.fade, maxLines: 4),
                            ])()
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
