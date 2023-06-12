import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/user_session.dart';
import 'package:volume_vault/pages/book_info_view/book_info_viewer_page.dart';
import 'package:volume_vault/pages/configuration_page/configuration_page.dart';
import 'package:volume_vault/pages/home_page/home_page.dart';
import 'package:volume_vault/pages/login_signin_page/login_signin_page.dart';
import 'package:volume_vault/pages/register_edit_book_page/pages/select_book_genre.dart';
import 'package:volume_vault/pages/register_edit_book_page/register_edit_book_page.dart';
import 'package:volume_vault/pages/register_edit_book_page/pages/large_info_input.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';

GoRouter buildDriver({UserSession? userSession}) => GoRouter(
        initialLocation: AppRoutes.homePageRoute,
        redirect: (context, state) {
          if (userSession == null) {
            return AppRoutes.loginSigninPage;
          }
          return null;
        },
        routes: [
          GoRoute(
            path: AppRoutes.homePageRoute,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.loginSigninPage,
            builder: (context, state) => const LoginSigninPage(),
          ),
          GoRoute(
            path: AppRoutes.bookInfoViewerPageRoute,
            builder: (context, state) {
              final List<Object> args = state.extra! as List<Object>;

              final bookModel = args[0] as BookModel;
              final onCardPressed =
                  args[1] as Future<void> Function(String, BuildContext)?;

              return BookInfoViewerPage(
                bookModel,
                onCardPressed: onCardPressed,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.registerEditBookPageRoute,
            builder: (context, state) {
              final List<Object> args = state.extra! as List<Object>;
              final BookModel? bookToEdit = args[0] as BookModel?;

              return RegisterEditBookPage(
                editBookModel: bookToEdit,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.largeInfoInputPageRoute,
            builder: (context, state) {
              final List<Object> args = state.extra! as List<Object>;

              final initialObservationText = args[0] as String;
              final initialSynopsisText = args[1] as String;

              return LargeInfoInput(
                initialObservationText: initialObservationText,
                initialSynopsisText: initialSynopsisText,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.selectBookGenrePageRoute,
            builder: (context, state) {
              final List<Object> args = state.extra! as List<Object>;

              final Set<String>? allreadySelectedGenres =
                  args[0] as Set<String>?;

              return SelectBookGenre(
                allreadyAddedGenres: allreadySelectedGenres,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.configurationsPageRoute,
            builder: (context, state) {
              return const ConfigurationPage();
            },
          ),
        ]);
