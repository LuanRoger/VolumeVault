import 'package:flutter/material.dart';
import "package:volume_vault/shared/theme/text_themes.dart";
import 'package:volume_vault/shared/widgets/cards/book_info_card.dart';
import 'package:volume_vault/shared/widgets/fx/fade.dart';

class BookInfoListCard extends BookInfoCard {
  double? height;

  BookInfoListCard(super.bookModel,
      {super.key, required super.onPressed, this.height = 150});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onPressed,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              if (bookModel.coverLink != null)
                Fade(
                  child: Image.network(
                    bookModel.coverLink!,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    width: 230,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.image_not_supported_rounded),
                    ),
                  ),
                )
              else
                const SizedBox(),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 2.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 0,
                        child: Text(
                          bookModel.title,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          style:
                              titleLarge.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        flex: 0,
                        child: Text(
                          bookModel.author,
                          overflow: TextOverflow.fade,
                          style: titleSmall.copyWith(fontSize: 20),
                        ),
                      ),
                      const Spacer(),
                      if (bookModel.synopsis != null)
                        Flexible(
                          flex: 10,
                          child: Text(
                            bookModel.synopsis!,
                            overflow: TextOverflow.fade,
                            maxLines: 5,
                          ),
                        )
                      else
                        const SizedBox()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
