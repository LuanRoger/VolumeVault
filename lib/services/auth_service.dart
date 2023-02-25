import 'dart:convert';

import 'package:volume_vault/models/http_response.dart';
import 'package:volume_vault/models/interfaces/http_module.dart';
import 'package:volume_vault/services/models/user_login_request.dart';
import 'package:volume_vault/services/models/user_sigin_request.dart';
import 'package:volume_vault/shared/consts.dart';

class AuthService {
  late final HttpModule _httpModule;

  AuthService({required String apiKey}) {
    _httpModule =
        HttpModule(fixHeaders: {Consts.API_KEY_REQUEST_HEADER: apiKey});
  }

  final String _baseUrl = "http://localhost:5000/auth/";
  String get _siginUrl => "${_baseUrl}signin";
  String get _loginUrl => "${_baseUrl}login";

  Future<HttpResponse> sigin(UserSiginRequest userRequest) async {
    final String userJsonInfo = json.encode(userRequest);

    final HttpResponse response =
        await _httpModule.post(_siginUrl, data: userJsonInfo);
    return response;
  }

  Future<HttpResponse> login(UserLoginRequest userRequest) async {
    final String userJsonInfo = json.encode(userRequest);

    final HttpResponse response =
        await _httpModule.post(_loginUrl, data: userJsonInfo);
    return response;
  }
}
