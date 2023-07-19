import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:volume_vault/l10n/supported_locales.dart';
import 'package:volume_vault/models/enums/book_format.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class L10n {
  static List<Locale> get locales => List.from(
      SupportedLocales.values.map((e) => e.locale).toList(growable: false));

  static SupportedLocales getLocaleFromCode(int code) {
    try {
      return SupportedLocales.values.firstWhere((e) => e.code == code);
    } catch (_) {
      return SupportedLocales.ptBR;
    }
  }

  static String formatDateByLocale(SupportedLocales locale, DateTime date) {
    switch (locale) {
      case SupportedLocales.enUS:
        return DateFormat('MM/dd/yyyy').format(date);
      case SupportedLocales.ptBR:
        return DateFormat('dd/MM/yyyy').format(date);
      default:
        return DateFormat('MM/dd/yyyy').format(date);
    }
  }

  static String bookFormat(BuildContext context, {required BookFormat format}) {
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
}
