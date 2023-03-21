import 'package:flutter/material.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/pages/home_page/sections/commands/home_section_layout_strategy.dart';

class HomeSectionDesktopCommands extends HomeSectionLayoutStrategy {
  const HomeSectionDesktopCommands();

  @override
  void onBookSelect(BuildContext context, BookModel bookModel,
      {void Function()? onUpdate}) {
        //Implemented on the caller, because this method change some state.
        //Check the method reference.
      }
}
