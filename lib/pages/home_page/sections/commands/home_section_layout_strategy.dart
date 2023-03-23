import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/book_search_result.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/providers/providers.dart';
import 'package:volume_vault/services/models/get_user_book_request.dart';
import 'package:volume_vault/services/models/user_book_result.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';
import 'package:volume_vault/shared/widgets/book_info_scrollable_tiles/book_info_card.dart';
import 'package:volume_vault/shared/widgets/book_info_scrollable_tiles/book_info_grid_card.dart';
import 'package:volume_vault/shared/widgets/book_info_scrollable_tiles/book_info_list_card.dart';
import 'package:volume_vault/shared/widgets/book_search_result_tile.dart';

abstract class HomeSectionLayoutStrategy {
  const HomeSectionLayoutStrategy();

  void onBookSelect(BuildContext context, BookModel bookModel,
      {void Function()? onUpdate});

  Future<List<BookSearchResult>> search(String query, WidgetRef ref) async {
    final bookController = await ref.read(bookControllerProvider.future);

    List<BookSearchResult> searchResult =
        await bookController.searchUserBooks(query);
    return searchResult;
  }

  Future<List<BookSearchResultTile>> buildSearhResultTiles(
      String query, BuildContext dialogContext, WidgetRef ref) async {
    return await search(query, ref).then((searchResult) => [
          for (final bookResult in searchResult)
            BookSearchResultTile(
              bookResult,
              onTap: () async {
                final bookController =
                    await ref.read(bookControllerProvider.future);
                final BookModel? book =
                    await bookController.getBookInfoById(bookResult.id);

                if (book == null) return;
                onBookSelect(dialogContext, book);
              },
            )
        ]);
  }

  Future<UserBookResult> fetchUserBooks(
      WidgetRef ref, GetUserBookRequest getUserBookRequest) async {
    final bookController = await ref.read(bookControllerProvider.future);

    UserBookResult userBookResult =
        await bookController.getUserBooks(getUserBookRequest);
    return userBookResult;
  }

  BookInfoCard buildBookView(BuildContext context,
      {required BookModel book,
      void Function()? onUpdate,
      void Function(BookModel)? onSelect,
      VisualizationType viewType = VisualizationType.LIST}) {
    switch (viewType) {
      case VisualizationType.LIST:
        return BookInfoListCard(
          book,
          onPressed: onSelect != null
              ? () => onSelect(book)
              : () => onBookSelect(context, book, onUpdate: onUpdate),
        );
      case VisualizationType.GRID:
        return BookInfoGridCard(
          book,
          onPressed: onSelect != null
              ? () => onSelect(book)
              : () => onBookSelect(context, book, onUpdate: onUpdate),
        );
    }
  }

  Future<void> showLogoutDialog(BuildContext context, WidgetRef ref) async {
    bool exit = false;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text("Sair da conta?"),
          content: const Text("Deseja realmente sair da conta?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                exit = true;
                Navigator.pop(context);
              },
              child: const Text("Sair"),
            ),
          ]),
    );

    if (exit) {
      await ref.read(userSessionNotifierProvider.notifier).clear();
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.loginPageRoute, (_) => false);
    }
  }
}
