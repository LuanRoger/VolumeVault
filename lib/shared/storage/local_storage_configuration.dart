import 'package:realm/realm.dart';
import 'package:volume_vault/shared/storage/models/server_config.dart';

final realmConfiguration = Configuration.local([ServerConfig.schema]);
final Realm realm = Realm(realmConfiguration);
