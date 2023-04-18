import 'package:flutter/material.dart';
import 'package:volume_vault/shared/widgets/cards/title_card.dart';

class TitleTextCard extends TitleCard {
  TitleTextCard(
      {super.key, required String title, required String content, bool? expand})
      : super(
            title: Text(title),
            content: Text(content),
            expand: expand ?? false);
}
