import "package:flutter/material.dart";

enum SupportedLocales {
  ptBR(0, Locale("pt")),
  enUS(1, Locale("en"));

  final int code;
  final Locale locale;

  const SupportedLocales(this.code, this.locale);
}
