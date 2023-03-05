import 'dart:convert';

import 'package:volume_vault/models/api_config_params.dart';
import 'package:volume_vault/models/http_response.dart';
import 'package:volume_vault/models/interfaces/http_module.dart';
import 'package:volume_vault/services/models/login_result.dart';
import 'package:volume_vault/services/models/sigin_result.dart';
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
  String get _userInfoUrl => "$_baseUrl/";
  String get _siginUrl => "$_baseUrl/signin";
  String get _loginUrl => "$_baseUrl/login";

  Future<HttpResponse> getUserInfo(String userAuthToken) async {
    return await _httpModule.get(_userInfoUrl,
        headers: {Consts.AUTHORIZATION_REQUEST_HEADER: "Bearer $userAuthToken"});
  }

  Future<SiginResult> sigin(UserSiginRequest userRequest) async {
    final String userJsonInfo = json.encode(userRequest);
    final HttpResponse response =
        await _httpModule.post(_siginUrl, body: userJsonInfo);
        
    return SiginResult(
        jwtToken: response.body, requestCode: response.statusCode);
  }

  Future<LoginResult> login(UserLoginRequest userRequest) async {
    final String jsonRequestBody = json.encode(userRequest);
    final HttpResponse response = await _httpModule.post(_loginUrl, body: jsonRequestBody);

    return LoginResult(
        jwtToken: response.body, requestCode: response.statusCode);
  }
}
