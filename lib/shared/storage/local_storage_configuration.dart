import 'package:realm/realm.dart';
import 'package:volume_vault/shared/storage/models/server_config.dart';
import 'package:volume_vault/shared/storage/models/user_session.dart';

final realmConfiguration = Configuration.local([UserSession.schema, ServerConfig.schema]);
late final Realm realm = Realm(realmConfiguration);