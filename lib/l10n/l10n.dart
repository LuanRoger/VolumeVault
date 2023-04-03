import 'package:flutter/material.dart';
import 'package:volume_vault/l10n/supported_locales.dart';

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
