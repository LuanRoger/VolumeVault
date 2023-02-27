import 'dart:convert';

import 'package:volume_vault/models/api_config_params.dart';
import 'package:volume_vault/models/http_response.dart';
import 'package:volume_vault/models/interfaces/http_module.dart';
import 'package:volume_vault/services/models/user_login_request.dart';
import 'package:volume_vault/services/models/user_sigin_request.dart';
import 'package:volume_vault/shared/consts.dart';

class AuthService {
  late final HttpModule _httpModule;
  final ApiConfigParams _apiConfig;

  AuthService({required ApiConfigParams apiConfig}) : _apiConfig = apiConfig {
    _httpModule = HttpModule(
        fixHeaders: {Consts.API_KEY_REQUEST_HEADER: _apiConfig.apiKey});
  }

  String get _baseUrl =>
      "${_apiConfig.protocol}://${_apiConfig.host}:${_apiConfig.port}/auth";
  String get _siginUrl => "$_baseUrl/signin";
  String get _loginUrl => "$_baseUrl/login";

  Future<HttpResponse> sigin(UserSiginRequest userRequest) async {
    final String userJsonInfo = json.encode(userRequest);

    final HttpResponse response =
        await _httpModule.post(_siginUrl, body: userJsonInfo);
    return response;
  }

  Future<HttpResponse> login(UserLoginRequest userRequest) async {
    final String userJsonInfo = json.encode(userRequest);

    final HttpResponse response =
        await _httpModule.post(_loginUrl, body: userJsonInfo);
    return response;
  }
}
