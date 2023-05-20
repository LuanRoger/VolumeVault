class ServerNotConfiguredException implements Exception {
  static const String cause =
      "Server not configured. Set the server variables in a .env file";

  ServerNotConfiguredException();
}
