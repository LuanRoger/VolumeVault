import 'package:flutter/material.dart' hide BottomSheet;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/pages/register_edit_book_page/layout/register_edit_book_desktop.dart';
import 'package:volume_vault/pages/register_edit_book_page/layout/register_edit_book_mobile.dart';

class RegisterEditBookPage extends HookWidget {
  final BookModel? editBookModel;

  const RegisterEditBookPage({super.key, this.editBookModel});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper.of(context).isDesktop ||
            ResponsiveWrapper.of(context).isTablet
        ? RegisterEditBookPageDesktop(editBookModel: editBookModel)
        : RegisterEditBookPageMobile(editBookModel: editBookModel);
  }
}
