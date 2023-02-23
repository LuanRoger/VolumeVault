import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/shared/preferences/models/server_preferences.dart';

class ServerPreferencesState extends StateNotifier<ServerPreferences> {
  ServerPreferencesState({required ServerPreferences serverPreferences})
      : super(serverPreferences);
}
