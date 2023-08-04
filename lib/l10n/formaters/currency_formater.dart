import "package:intl/intl.dart";
import "package:volume_vault/l10n/supported_locales.dart";

String formatCurrency(SupportedLocales locale, dynamic value) {
  final formater = NumberFormat("#,##", locale.locale.languageCode);

  return formater.format(value);
}
