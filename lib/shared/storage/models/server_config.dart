import 'package:realm/realm.dart';

part 'server_config.g.dart';

@RealmModel()
class _ServerConfig {
  @PrimaryKey()
  late int id;
  late String serverPort;
  late String serverHost;
  late String serverApiKey;
  late String serverProtocol;

  late String searchServerPort;
  late String searchServerHost;
  late String searchServerApiKey;
  late String searchServerProtocol;

  late bool useEnvVars;
}
