import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/book_search_result.dart';
import 'package:volume_vault/models/book_sort_option.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/pages/book_info_view/commands/book_info_viewer_strategy.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/book_search_request.dart';
import 'package:volume_vault/services/models/book_stats.dart';
import 'package:volume_vault/services/models/get_user_book_request.dart';
import 'package:volume_vault/services/models/user_book_result.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/widgets/cards/book_info_grid_card.dart';
import 'package:volume_vault/shared/widgets/cards/book_info_list_card.dart';
import 'package:volume_vault/shared/widgets/cards/profile_card.dart';
import 'package:volume_vault/shared/widgets/list_tiles/book_search_result_tile.dart';

abstract class HomeSectionLayoutStrategy {
  const HomeSectionLayoutStrategy();

  void onBookSelect(BuildContext context, WidgetRef ref, BookModel bookModel,
      {void Function()? onUpdate});

  Future<BookSearchResult?> search(String query, WidgetRef ref) async {
    final bookSearchController =
        await ref.read(bookSearchControllerProvider.future);
    BookSearchRequest searchRequest =
        BookSearchRequest(query: query, limitPerPage: 10);

    BookSearchResult? searchResult =
        await bookSearchController.searchForBook(searchRequest);

    return searchResult;
  }

  Future<void> showProfileCard(BuildContext context,
      {double? heightFactor, double? widthFactor}) async {
    final profileCard = ProfileCard(
      heightFactor: heightFactor,
      widthFactor: widthFactor,
    );
    await profileCard.show(context);
  }

  List<Widget> buildSearhResultTiles(BookSearchResult searchResult,
      BuildContext dialogContext, WidgetRef ref) {
    return [
      for (final bookResult in searchResult.results)
        BookSearchResultTile(
          bookResult,
          onTap: () async {
            final bookController =
                await ref.read(bookControllerProvider.future);
            final BookModel? book =
                await bookController.getBookInfoById(bookResult.id);

            if (book == null) return;
            onBookSelect(dialogContext, ref, book);
          },
        )
    ];
  }

  Future<UserBookResult> fetchUserBooks(
      WidgetRef ref, GetUserBookRequest getUserBookRequest) async {
    final bookController = await ref.read(bookControllerProvider.future);

    final userBookResult =
        await bookController.getUserBooks(getUserBookRequest);
    return userBookResult;
  }

  Future<BookStats?> getUserBookStats(WidgetRef ref) async {
    final statsController = await ref.read(statsControllerProvider.future);

    BookStats? bookStats = await statsController.getUserBooksCount();
    return bookStats;
  }

  Widget buildBookView(BuildContext context, WidgetRef ref,
      {required BookModel book,
      required BookInfoViewerStrategy bookInfoViewerStrategy,
      void Function()? onUpdate,
      void Function(BookModel)? onSelect,
      VisualizationType viewType = VisualizationType.LIST}) {
    final slidableBackgroundColor = Theme.of(context).colorScheme.surface;
    return switch (viewType) {
      VisualizationType.LIST => Slidable(
          closeOnScroll: true,
          endActionPane: ActionPane(
              motion: const BehindMotion(),
              extentRatio: 0.3,
              children: [
                SlidableAction(
                    backgroundColor: slidableBackgroundColor,
                    onPressed: (context) {
                      context.push(AppRoutes.registerEditBookPageRoute,
                          extra: [book, true]);
                    },
                    icon: Icons.edit_rounded),
                SlidableAction(
                    backgroundColor: slidableBackgroundColor,
                    onPressed: (context) => bookInfoViewerStrategy
                        .showBookShareQrCode(context, bookModel: book),
                    icon: Icons.share_rounded),
              ]),
          child: BookInfoListCard(
            book,
            onPressed: onSelect != null
                ? () => onSelect(book)
                : () => onBookSelect(context, ref, book, onUpdate: onUpdate),
          ),
        ),
      VisualizationType.GRID => BookInfoGridCard(
          book,
          onPressed: onSelect != null
              ? () => onSelect(book)
              : () => onBookSelect(context, ref, book, onUpdate: onUpdate),
        )
    };
  }

  Future<BookSortOption?> showSortFilterDialog(BuildContext context,
      {bool wrapped = true, BookSortOption? currentOptions});
}
