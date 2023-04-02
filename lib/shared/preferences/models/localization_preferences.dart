import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:volume_vault/l10n/supported_locales.dart';

part 'localization_preferences.freezed.dart';

@freezed
class LocalizationPreferences with _$LocalizationPreferences {
  const factory LocalizationPreferences({
    required SupportedLocales localization,
  }) = _LocalizationPreferences;
}
