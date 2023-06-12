import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_vault/l10n/supported_locales.dart';
import 'package:volume_vault/shared/preferences/models/localization_preferences.dart';
import 'package:volume_vault/shared/preferences/preferences_keys.dart';

class LocalizationPreferencesState
    extends StateNotifier<LocalizationPreferences> {
  final SharedPreferences _preferences;

  LocalizationPreferencesState(this._preferences,
      {LocalizationPreferences? localizationPreferences})
      : super(localizationPreferences ??
            const LocalizationPreferences(localization: SupportedLocales.ptBR));

  void changeLocalization(SupportedLocales locale) {
    state = state.copyWith(localization: locale);
    _preferences.setInt(PreferencesKeys.localizationPrefKey, locale.index);
  }

  void reset() {
    state = const LocalizationPreferences(localization: SupportedLocales.ptBR);
    _preferences.setInt(
        PreferencesKeys.localizationPrefKey, SupportedLocales.ptBR.index);
  }
}
