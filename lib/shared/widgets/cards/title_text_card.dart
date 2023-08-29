import "package:flutter/material.dart";
import "package:volume_vault/shared/widgets/cards/title_card.dart";

class TitleTextCard extends TitleCard {
  TitleTextCard(
      {required String title, required String content, super.key, bool? expand})
      : super(
          title: Text(title),
          content: Text(content),
          expand: expand ?? false,
        );
}
