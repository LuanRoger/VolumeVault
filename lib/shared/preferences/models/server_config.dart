import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_config.freezed.dart';
part 'server_config.g.dart';

@freezed
class ServerConfig with _$ServerConfig {
  const factory ServerConfig({
    required String serverHost,
    required String serverPort,
    required String serverApiKey,
    required String serverProtocol,
    required String searchServerHost,
    required String searchServerPort,
    required String searchServerApiKey,
    required String searchServerProtocol,
  }) = _ServerConfig;

  factory ServerConfig.fromJson(Map<String, Object?> json) =>
      _$ServerConfigFromJson(json);
}
