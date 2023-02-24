import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_vault/models/enums/theme_brightness.dart';
import 'package:volume_vault/shared/preferences/models/graphics_preferences.dart';
import 'package:volume_vault/shared/preferences/models/server_preferences.dart';
import 'package:volume_vault/shared/preferences/models/theme_preferences.dart';
import 'package:volume_vault/shared/preferences/preferences_key.dart';

class AppPreferences extends ChangeNotifier {
  late ThemePreferences _themePreferences;
  late GraphicsPreferences _graphicsPreferences;
  late ServerPreferences _serverPreferences;
  late final SharedPreferences _preferences;

  AppPreferences(this._preferences);

  Future loadPreferences() async {
    _themePreferences = ThemePreferences(
        themeBrightnes: ThemeBrightness
            .values[_preferences.getInt(PreferencesKey.themeModePrefKey) ?? 0]);
    _graphicsPreferences = GraphicsPreferences(
        lightEffect:
            _preferences.getBool(PreferencesKey.lightEffectPrefKey) ?? true);
    _serverPreferences = ServerPreferences(
        serverHost:
            _preferences.getString(PreferencesKey.serverHostPrefKey) ?? "",
        serverPort:
            _preferences.getString(PreferencesKey.serverPortPrefKey) ?? "",
        serverApiKey:
            _preferences.getString(PreferencesKey.serverApiKeyPrefKey) ?? "",
        serverProtocol:
            _preferences.getInt(PreferencesKey.serverProtocolPrefKey) ?? 0);
  }

  ThemePreferences get themePreferences => _themePreferences;
  set themeBrightness(int newValue) {
    assert(newValue >= 0 && newValue < ThemeBrightness.values.length);

    _themePreferences = _themePreferences.copyWith(
        themeBrightnes: ThemeBrightness.values[newValue]);
    _preferences.setInt(PreferencesKey.themeModePrefKey, newValue);

    notifyListeners();
  }

  GraphicsPreferences get graphicsPreferences => _graphicsPreferences;
  set lightEffect(bool newValue) {
    _graphicsPreferences = _graphicsPreferences.copyWith(lightEffect: newValue);
    _preferences.setBool(PreferencesKey.lightEffectPrefKey, newValue);

    notifyListeners();
  }

  ServerPreferences get serverPreferences => _serverPreferences;
  set serverHost(String newValue) {
    _serverPreferences = _serverPreferences.copyWith(serverHost: newValue);
    _preferences.setString(PreferencesKey.serverHostPrefKey, newValue);

    notifyListeners();
  }

  set serverPort(String newValue) {
    _serverPreferences = _serverPreferences.copyWith(serverPort: newValue);
    _preferences.setString(PreferencesKey.serverPortPrefKey, newValue);

    notifyListeners();
  }

  set serverApiKey(String newValue) {
    _serverPreferences = _serverPreferences.copyWith(serverApiKey: newValue);
    _preferences.setString(PreferencesKey.serverApiKeyPrefKey, newValue);

    notifyListeners();
  }

  set serverProtocol(int newValue) {
    _serverPreferences = _serverPreferences.copyWith(serverProtocol: newValue);
    _preferences.setInt(PreferencesKey.serverProtocolPrefKey, newValue);

    notifyListeners();
  }

  void setAllServerPref(
      {required String host, required String port, required String apiKey}) {
    _serverPreferences = _serverPreferences.copyWith(
      serverHost: host,
      serverPort: port,
      serverApiKey: apiKey,
    );
    _preferences.setString(PreferencesKey.serverHostPrefKey, host);
    _preferences.setString(PreferencesKey.serverPortPrefKey, port);
    _preferences.setString(PreferencesKey.serverApiKeyPrefKey, apiKey);

    notifyListeners();
  }

  Future restartPreferences() async {
    _preferences.clear();
    await loadPreferences();

    notifyListeners();
  }
}
