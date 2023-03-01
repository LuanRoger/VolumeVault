import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/shared/storage/local_storage_configuration.dart';
import 'package:volume_vault/shared/storage/models/user_session.dart';

class UserSessionNotifier extends AsyncNotifier<UserSession> {
  UserSessionNotifier({UserSession? userSession}) : super();

  @override
  FutureOr<UserSession> build() async {
    UserSession? userSession = realm.find<UserSession>(0);
    if (userSession == null) {
      final defaultUser = UserSession(0, "");
      await realm.writeAsync(() {
        userSession = realm.add(defaultUser);
      });
    } else {
      userSession = userSession;
    }

    return userSession!;
  }

  String get userSessionToken => state.requireValue.token;
  Future changeUserSessionToken(String token) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return await realm.writeAsync<UserSession>(() {
        UserSession user = realm.find<UserSession>(0)!;
        user.token = token;
        return user;
      });
    });
  }

  Future clear() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return await realm.writeAsync<UserSession>(() {
        UserSession user = realm.find<UserSession>(0)!;
        user.token = "";

        return user;
      });
    });
  }
}
