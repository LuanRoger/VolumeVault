import 'package:flutter/foundation.dart';
import 'package:realm/realm.dart';
import 'package:volume_vault/shared/storage/models/user_session.dart';

class AppStorage extends ChangeNotifier {
  late final Realm _realm;

  late final UserSession _userSession;

  Future init(Configuration realmConfiguration) async {
    _realm = Realm(realmConfiguration);

    UserSession? userSession = _realm.find<UserSession>(0);
    if (userSession == null) {
      final defaultUser = UserSession(0, "");
      await _realm.writeAsync(() {
        _userSession = _realm.add(defaultUser);
      });
    } else {
      _userSession = userSession;
    }
  }

  UserSession get userSession => _userSession;
  Future changeUserSessionToken(String token) async {
    await _realm.writeAsync(() {
      _userSession.token = token;
    });

    notifyListeners();
  }

  Future clearUserSession() async {
    await _realm.writeAsync(() {
      _userSession.token = "";
    });

    notifyListeners();
  }

  Future clearAll() async {
    await clearUserSession();
  }

  void close() {
    _realm.close();
  }
}
