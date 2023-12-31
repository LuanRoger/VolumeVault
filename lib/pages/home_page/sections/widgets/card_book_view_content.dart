import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:volume_vault/models/book_model.dart";
import "package:volume_vault/pages/book_info_view/book_info_viewer_page.dart";
import "package:volume_vault/shared/widgets/placeholders/no_book_selected_placeholder.dart";

class CardBookViewContent extends ConsumerWidget {
  final BookModel? book;
  final Future<void> Function() onRefresh;
  final Future<void> Function(String, BuildContext)? onCardPressed;

  const CardBookViewContent({
    required this.book,
    required this.onRefresh,
    super.key,
    this.onCardPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AnimatedSize(
          alignment: Alignment.topCenter,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutQuart,
          child: SizedBox(
            width: double.infinity,
            child: book != null
                ? BookInfoViwerBodyPage(
                    book!,
                    onRefresh: onRefresh,
                    onCardPressed: onCardPressed,
                  )
                : const NoBookSelectedPlaceholder(),
          )),
    );
  }
}
