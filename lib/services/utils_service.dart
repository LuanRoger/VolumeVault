import 'package:volume_vault/models/api_config_params.dart';
import 'package:volume_vault/models/http_response.dart';
import 'package:volume_vault/models/interfaces/http_module.dart';
import 'package:volume_vault/shared/consts.dart';

class UtilsService {
  late final HttpModule _httpModule;
  final ApiConfigParams _apiConfig;

  UtilsService({required ApiConfigParams apiConfigParams})
      : _apiConfig = apiConfigParams {
    _httpModule = HttpModule(
        fixHeaders: {Consts.API_KEY_REQUEST_HEADER: _apiConfig.apiKey});
  }

  String get _baseUrl =>
      "${_apiConfig.protocol}://${_apiConfig.host}:${_apiConfig.port}/utils";
  String get _pingUrl => "$_baseUrl/ping";
  String get _checkAuthTokenUrl => "$_baseUrl/check-auth-token";

  Future<HttpResponse> ping() {
    return _httpModule.get(_pingUrl);
  }

  Future<HttpResponse> checkAuthToken(String authToken) {
    return _httpModule.get(_checkAuthTokenUrl,
        headers: {Consts.AUTHORIZATION_REQUEST_HEADER: authToken});
  }
}
