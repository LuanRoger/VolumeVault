import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_vault/shared/preferences/models/graphics_preferences.dart';
import 'package:volume_vault/shared/preferences/preferences_keys.dart';

class GraphicsPreferencesState extends StateNotifier<GraphicsPreferences> {
  final SharedPreferences _preferences;

  GraphicsPreferencesState(this._preferences,
      {GraphicsPreferences? graphicsPreferences})
      : super(graphicsPreferences ??
            const GraphicsPreferences(lightEffect: true));

  bool get lightEffect => state.lightEffect;
  set lightEffect(bool newValue) {
    state = state.copyWith(lightEffect: newValue);
    _preferences.setBool(PreferencesKeys.lightEffectPrefKey, newValue);
  }

  void reset() {
    state = const GraphicsPreferences(lightEffect: true);
    _preferences.setBool(PreferencesKeys.lightEffectPrefKey, state.lightEffect);
  }
}
