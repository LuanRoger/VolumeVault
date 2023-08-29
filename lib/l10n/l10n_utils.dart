import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:volume_vault/models/enums/book_format.dart";
import "package:volume_vault/models/enums/theme_brightness.dart";

String localizeBookFormat(BuildContext context, {required BookFormat format}) {
  return switch (format) {
    BookFormat.hardcover =>
      AppLocalizations.of(context)!.hardcoverRegisterBookFormatOption,
    BookFormat.hardback =>
      AppLocalizations.of(context)!.hardbackRegisterBookFormatOption,
    BookFormat.paperback =>
      AppLocalizations.of(context)!.paperbackRegisterBookFormatOption,
    BookFormat.ebook =>
      AppLocalizations.of(context)!.ebookRegisterBookFormatOption,
    BookFormat.pocket =>
      AppLocalizations.of(context)!.pocketBookRegisterBookFormatOption,
    BookFormat.audioBook =>
      AppLocalizations.of(context)!.audiobookRegisterBookFormatOption,
    BookFormat.spiral =>
      AppLocalizations.of(context)!.spiralBoundRegisterBookFormatOption,
    BookFormat.hq => AppLocalizations.of(context)!.hqRegisterBookFormatOption,
    BookFormat.collectorsEdition =>
      AppLocalizations.of(context)!.collectorsEditionRegisterBookFormatOption,
  };
}

String localizeTheme(BuildContext context,
    {required ThemeBrightness brightness}) {
  return switch (brightness) {
    ThemeBrightness.light =>
      AppLocalizations.of(context)!.lightThemeSelectionDialogOption,
    ThemeBrightness.dark =>
      AppLocalizations.of(context)!.darkThemeSelectionDialogOption,
    ThemeBrightness.system =>
      AppLocalizations.of(context)!.systemThemeSelectionDialogOption,
  };
}
