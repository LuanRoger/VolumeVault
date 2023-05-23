import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/shared/storage/local_storage_configuration.dart';
import 'package:volume_vault/shared/storage/models/server_config.dart';
import 'package:volume_vault/shared/utils/env_vars.dart';

class ServerConfigNotifier extends AsyncNotifier<ServerConfig> {
  @override
  FutureOr<ServerConfig> build() async {
    ServerConfig? savedServerConfig = realm.find<ServerConfig>(0);
    ServerConfig serverConfig = ServerConfig(0, "", "", "", "", "", "", "", "", true);
    if (savedServerConfig == null) {
      serverConfig.serverHost = EnvVars.apiHost;
      serverConfig.serverPort = EnvVars.apiPort;
      serverConfig.serverApiKey = EnvVars.apiKey;
      serverConfig.serverProtocol = EnvVars.apiProtocol;

      serverConfig.searchServerHost = EnvVars.searchApiHost;
      serverConfig.searchServerPort = EnvVars.searchApiPort;
      serverConfig.searchServerApiKey = EnvVars.searchApiKey;
      serverConfig.searchServerProtocol = EnvVars.searchApiProtocol;

      await realm.writeAsync(() {
        serverConfig = realm.add(serverConfig);
      });
    } else {
      serverConfig = savedServerConfig;
      if (savedServerConfig.useEnvVars) {
        realm.writeAsync(() {
          serverConfig.serverHost = EnvVars.apiHost;
          serverConfig.serverPort = EnvVars.apiPort;
          serverConfig.serverApiKey = EnvVars.apiKey;
          serverConfig.serverProtocol = EnvVars.apiProtocol;

          serverConfig.searchServerHost = EnvVars.searchApiHost;
          serverConfig.searchServerPort = EnvVars.searchApiPort;
          serverConfig.searchServerApiKey = EnvVars.searchApiKey;
          serverConfig.searchServerProtocol = EnvVars.searchApiProtocol;
        });
      }
    }

    return serverConfig;
  }

  Future changeServerHost(String serverHost) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return await realm.writeAsync(() {
        ServerConfig serverConfig = realm.find<ServerConfig>(0)!;
        serverConfig.serverHost = serverHost;

        return serverConfig;
      });
    });
  }

  Future changeServerPort(String serverPort) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return await realm.writeAsync(() {
        ServerConfig serverConfig = realm.find<ServerConfig>(0)!;
        serverConfig.serverPort = serverPort;

        return serverConfig;
      });
    });
  }

  Future changeServerApiKey(String serverApiKey) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return await realm.writeAsync(() {
        ServerConfig serverConfig = realm.find<ServerConfig>(0)!;
        serverConfig.serverApiKey = serverApiKey;

        return serverConfig;
      });
    });
  }

  Future changeServerProtocol(String serverProtocol) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return await realm.writeAsync(() {
        ServerConfig serverConfig = realm.find<ServerConfig>(0)!;
        serverConfig.serverProtocol = serverProtocol;

        return serverConfig;
      });
    });
  }

  Future toggleUseEnvVars() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return await realm.writeAsync(() {
        ServerConfig serverConfig = realm.find<ServerConfig>(0)!;
        serverConfig.useEnvVars = !serverConfig.useEnvVars;

        return serverConfig;
      });
    });
  }

  Future changeServerConfig(
      {required String serverHost,
      required String serverPort,
      required String serverApiKey,
      required String serverProtocol}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return await realm.writeAsync(() {
        ServerConfig serverConfig = realm.find<ServerConfig>(0)!;
        serverConfig.serverHost = serverHost;
        serverConfig.serverPort = serverPort;
        serverConfig.serverApiKey = serverApiKey;
        serverConfig.serverProtocol = serverProtocol;

        return serverConfig;
      });
    });
  }

  Future clear() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return await realm.writeAsync(() {
        ServerConfig serverConfig = realm.find<ServerConfig>(0)!;
        serverConfig.serverHost = "";
        serverConfig.serverPort = "";
        serverConfig.serverApiKey = "";
        serverConfig.serverProtocol = "";

        return serverConfig;
      });
    });
  }
}
