import 'package:flutter/material.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/pages/book_info_view/book_info_viewer_page.dart';
import 'package:volume_vault/pages/configuration_page.dart';
import 'package:volume_vault/pages/home_page/home_page.dart';
import 'package:volume_vault/pages/login_signin_page/login_signin_page.dart';
import 'package:volume_vault/pages/login_user_page/login_user_page.dart';
import 'package:volume_vault/pages/register_edit_book_page/register_edit_book_page.dart';
import 'package:volume_vault/pages/register_edit_book_page/sub_pages/large_info_input.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';

class RouteDriver {
  static Route<dynamic> driver(RouteSettings settings) {
    if (settings.arguments != null) assert(settings.arguments is List);

    List<Object>? pageArgs =
        settings.arguments != null ? settings.arguments as List<Object> : null;

    switch (settings.name) {
      case AppRoutes.homePageRoute:
        return gotoHomePage();
      case AppRoutes.loginPageRoute:
        return gotoLoginPage();
      case AppRoutes.loginSigninPage:
        return gotoLoginSigninPage();
      case AppRoutes.bookInfoViewerPageRoute:
        return gotoBookInfoViewerPage(pageArgs![0] as BookModel);
      case AppRoutes.registerEditBookPageRoute:
        return gotoRegisterEditBookPage(bookToEdit: pageArgs?[0] as BookModel);
      case AppRoutes.largeInfoInputPageRoute:
        return gotoLargeInfoInputPage(
            pageArgs![0] as String, pageArgs[1] as String);
      case AppRoutes.configurationsPageRoute:
        return gotoConfigurationPage();
      default:
        return gotoHomePage();
    }
  }

  static gotoHomePage() => MaterialPageRoute(builder: (_) => const HomePage());
  static gotoLoginPage() =>
      MaterialPageRoute(builder: (_) => const LoginUserPage());
  static gotoLoginSigninPage() =>
      MaterialPageRoute(builder: (_) => const LoginSigninPage());

  static gotoBookInfoViewerPage(BookModel bookModel) =>
      MaterialPageRoute<bool>(builder: (_) => BookInfoViewerPage(bookModel));
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
  static gotoConfigurationPage() =>
      MaterialPageRoute(builder: (_) => const ConfigurationPage());
}
