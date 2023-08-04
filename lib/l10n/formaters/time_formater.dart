import "package:intl/intl.dart";
import "package:volume_vault/l10n/supported_locales.dart";

String formatDateByLocale(SupportedLocales locale, DateTime date) {
  switch (locale) {
    case SupportedLocales.enUS:
      return DateFormat('MM/dd/yyyy').format(date);
    case SupportedLocales.ptBR:
      return DateFormat('dd/MM/yyyy').format(date);
    default:
      return DateFormat('MM/dd/yyyy').format(date);
  }
}
