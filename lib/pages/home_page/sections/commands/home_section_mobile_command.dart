import 'package:flutter/material.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/pages/home_page/sections/commands/home_section_layout_strategy.dart';
import 'package:volume_vault/shared/routes/app_routes.dart';

class HomeSectionMobileCommand extends HomeSectionLayoutStrategy {
  const HomeSectionMobileCommand();

  @override
  void onBookSelect(BuildContext context, BookModel bookModel,
      {void Function()? onUpdate}) {
    Navigator.pushNamed<bool>(context, AppRoutes.bookInfoViewerPageRoute,
        arguments: [bookModel]).then((value) {
      if (value == null || onUpdate == null) return;

      onUpdate.call();
    });
  }
}
