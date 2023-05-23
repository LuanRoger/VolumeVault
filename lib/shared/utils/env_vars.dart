import 'package:envied/envied.dart';

part 'env_vars.g.dart';

@Envied(path: ".env", obfuscate: true)
abstract class EnvVars {
  @EnviedField(varName: "VV_API_KEY", defaultValue: "", obfuscate: true)
  static final apiKey = _EnvVars.apiKey;
  @EnviedField(varName: "VV_SEARCH_API_KEY", defaultValue: "", obfuscate: true)
  static final searchApiKey = _EnvVars.searchApiKey;
  @EnviedField(
      varName: "VV_API_PROTOCOL", defaultValue: "http", obfuscate: false)
  static const apiProtocol = _EnvVars.apiProtocol;
  @EnviedField(varName: "VV_API_HOST", defaultValue: "", obfuscate: false)
  static const apiHost = _EnvVars.apiHost;
  @EnviedField(varName: "VV_API_PORT", defaultValue: "", obfuscate: false)
  static const apiPort = _EnvVars.apiPort;

  @EnviedField(
      varName: "VV_SEARCH_API_PROTOCOL", defaultValue: "", obfuscate: false)
  static const searchApiProtocol = _EnvVars.searchApiProtocol;
  @EnviedField(
      varName: "VV_SEARCH_API_HOST", defaultValue: "", obfuscate: false)
  static const searchApiHost = _EnvVars.searchApiHost;
  @EnviedField(
      varName: "VV_SEARCH_API_PORT", defaultValue: "", obfuscate: false)
  static const searchApiPort = _EnvVars.searchApiPort;
}
