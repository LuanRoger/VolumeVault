import 'package:flutter/material.dart';

enum SupportedLocales {
  ptBR(0, Locale("pt", "BR")),
  enUS(1, Locale("en", "US"));

  final int code;
  final Locale locale;

  const SupportedLocales(this.code, this.locale);
}
