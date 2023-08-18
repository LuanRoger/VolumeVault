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
}
