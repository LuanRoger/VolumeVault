import 'package:flutter/material.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/pages/book_info_view/book_info_viewer_page.dart';
import 'package:volume_vault/pages/configuration_page.dart';
import 'package:volume_vault/pages/home_page/home_page.dart';
import 'package:volume_vault/pages/login_signin_page/login_signin_page.dart';
import 'package:volume_vault/pages/register_edit_book_page/pages/select_book_genre.dart';
import 'package:volume_vault/pages/register_edit_book_page/register_edit_book_page.dart';
import 'package:volume_vault/pages/register_edit_book_page/pages/large_info_input.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';

class RouteDriver {
  static Route<dynamic> driver(RouteSettings settings) {
    if (settings.arguments != null) assert(settings.arguments is List);

    List<Object>? pageArgs =
        settings.arguments != null ? settings.arguments as List<Object> : null;

    switch (settings.name) {
      case AppRoutes.homePageRoute:
        return gotoHomePage();
      case AppRoutes.loginSigninPage:
        return gotoLoginSigninPage();
      case AppRoutes.bookInfoViewerPageRoute:
        return gotoBookInfoViewerPage(
          pageArgs![0] as BookModel,
          onCardPressed: pageArgs[1] as Future<void> Function(String, BuildContext)?,
        );
      case AppRoutes.registerEditBookPageRoute:
        return gotoRegisterEditBookPage(bookToEdit: pageArgs?[0] as BookModel);
      case AppRoutes.largeInfoInputPageRoute:
        return gotoLargeInfoInputPage(
            pageArgs![0] as String, pageArgs[1] as String);
      case AppRoutes.selectBookGenrePageRoute:
        return gotoSelectBookGenrePage(
            alreadySelectedGenres: pageArgs?[0] as Set<String>?);
      case AppRoutes.configurationsPageRoute:
        return gotoConfigurationPage();
      default:
        return gotoHomePage();
    }
  }

  static gotoHomePage() => MaterialPageRoute(builder: (_) => const HomePage());
  static gotoLoginSigninPage() =>
      MaterialPageRoute(builder: (_) => const LoginSigninPage());

  static gotoBookInfoViewerPage(BookModel bookModel,
          {Future<void> Function(String, BuildContext)? onCardPressed}) =>
      MaterialPageRoute<bool>(
          builder: (_) => BookInfoViewerPage(
                bookModel,
                onCardPressed: onCardPressed,
              ));
  static gotoRegisterEditBookPage({BookModel? bookToEdit}) =>
      MaterialPageRoute<bool>(
          builder: (_) => RegisterEditBookPage(editBookModel: bookToEdit));
  static gotoLargeInfoInputPage(String observationText, String synopsisText) =>
      MaterialPageRoute<List<String>>(
        builder: (_) => LargeInfoInput(
          initialObservationText: observationText,
          initialSynopsisText: synopsisText,
        ),
      );
  static gotoSelectBookGenrePage({Set<String>? alreadySelectedGenres}) =>
      MaterialPageRoute<Set<String>>(
          builder: (_) => SelectBookGenre(
                alreadyAddedGenres: alreadySelectedGenres,
              ));
  static gotoConfigurationPage() =>
      MaterialPageRoute(builder: (_) => const ConfigurationPage());
}
