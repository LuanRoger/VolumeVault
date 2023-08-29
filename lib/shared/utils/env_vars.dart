import "package:envied/envied.dart";

part "env_vars.g.dart";

@Envied(path: ".env", obfuscate: true)
abstract class EnvVars {
  @EnviedField(varName: "VV_API_KEY", defaultValue: "", obfuscate: true)
  static final String apiKey = _EnvVars.apiKey;
  @EnviedField(varName: "VV_SEARCH_API_KEY", defaultValue: "", obfuscate: true)
  static final String searchApiKey = _EnvVars.searchApiKey;
  @EnviedField(
      varName: "VV_API_PROTOCOL", defaultValue: "http", obfuscate: false)
  static const String apiProtocol = _EnvVars.apiProtocol;
  @EnviedField(varName: "VV_API_HOST", defaultValue: "", obfuscate: false)
  static const String apiHost = _EnvVars.apiHost;
  @EnviedField(varName: "VV_API_PORT", defaultValue: "", obfuscate: false)
  static const String apiPort = _EnvVars.apiPort;

  @EnviedField(
      varName: "VV_SEARCH_API_PROTOCOL", defaultValue: "", obfuscate: false)
  static const String searchApiProtocol = _EnvVars.searchApiProtocol;
  @EnviedField(
      varName: "VV_SEARCH_API_HOST", defaultValue: "", obfuscate: false)
  static const String searchApiHost = _EnvVars.searchApiHost;
  @EnviedField(
      varName: "VV_SEARCH_API_PORT", defaultValue: "", obfuscate: false)
  static const String searchApiPort = _EnvVars.searchApiPort;
}
