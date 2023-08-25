import "package:flutter/material.dart";
import "package:volume_vault/models/book_model.dart";

abstract class BookInfoCard extends StatelessWidget {
  final BookModel bookModel;
  final void Function() onPressed;

  const BookInfoCard(this.bookModel, {required this.onPressed, super.key});
}
