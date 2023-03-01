import 'package:realm/realm.dart';

part 'user_session.g.dart';

@RealmModel()
class _UserSession {
  @PrimaryKey()
  late int id;
  late String token;
}
