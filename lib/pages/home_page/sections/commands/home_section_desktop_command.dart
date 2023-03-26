import 'package:flutter/material.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/pages/home_page/sections/commands/home_section_layout_strategy.dart';

class HomeSectionDesktopCommand extends HomeSectionLayoutStrategy {
  late ValueNotifier<BookModel?> bookOnViwerState;

  HomeSectionDesktopCommand();

  @override
  void onBookSelect(BuildContext context, BookModel bookModel,
      {void Function()? onUpdate}) {
    bookOnViwerState.value = bookModel;
  }
}
