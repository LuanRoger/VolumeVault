import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_preferences.freezed.dart';

@freezed
class ServerPreferences with _$ServerPreferences {
  const factory ServerPreferences({
    required String serverHost,
    required String serverPort,
    required String serverApiKey,
    required int serverProtocol,
  }) = _ServerPreferences;
}
