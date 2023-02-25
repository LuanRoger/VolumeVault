import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/shared/utils/image_utils.dart';
import 'package:volume_vault/shared/widgets/book_image_viewer.dart';

class BookViewerCard extends HookConsumerWidget {
  final BookModel book;

  const BookViewerCard(this.book, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NetworkImage? coverImage =
        book.coverLink != null ? NetworkImage(book.coverLink!) : null;
    final dominantColor = useMemoized(
      () {
        if (coverImage == null) return null;

        return ImageUtils.getDominantColor(coverImage);
      },
    );
    final dominantColorFuture =
        useFuture<Color?>(dominantColor, initialData: null);

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            if (dominantColorFuture.hasData) dominantColorFuture.data!,
            Theme.of(context).colorScheme.surface
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.1, 0.5],
        ),
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (coverImage != null)
                    BookImageViewer(image: coverImage).animate(
                      effects: const [
                        FadeEffect(
                          curve: Curves.easeInOutQuart,
                          duration: Duration(milliseconds: 500),
                        )
                      ],
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        book.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        book.author,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
