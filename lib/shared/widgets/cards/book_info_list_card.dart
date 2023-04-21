import 'package:flutter/material.dart';
import 'package:volume_vault/shared/widgets/cards/book_info_card.dart';

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
              bookModel.coverLink != null
                  ? ShaderMask(
                      shaderCallback: (rect) => const LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [Colors.black, Colors.transparent],
                      ).createShader(
                          Rect.fromLTRB(0, 0, rect.width * 1.5, rect.height)),
                      blendMode: BlendMode.dstIn,
                      child: Image.network(
                        bookModel.coverLink!,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        width: 230,
                      ),
                    )
                  : const SizedBox(),
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
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Flexible(
                        flex: 0,
                        child: Text(
                          bookModel.author,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      const Spacer(),
                      bookModel.synopsis != null
                          ? Flexible(
                              flex: 10,
                              child: Text(
                                bookModel.synopsis!,
                                overflow: TextOverflow.fade,
                                maxLines: 5,
                              ),
                            )
                          : const SizedBox()
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
