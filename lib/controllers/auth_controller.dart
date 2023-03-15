import 'package:flutter/material.dart';
import 'package:volume_vault/services/auth_service.dart';
import 'package:volume_vault/services/models/login_result.dart';
import 'package:volume_vault/services/models/signin_result.dart';
import 'package:volume_vault/services/models/user_login_request.dart';
import 'package:volume_vault/services/models/user_signin_request.dart';

class AuthController {
  final AuthService _service;

  AuthController(this._service);

  Future<LoginResult> loginUser(UserLoginRequest loginRequest) async {
    LoginResult result = await _service.login(loginRequest);

    return result;
  }
  Future<SigninResult> signinUser(UserSigninRequest signinRequest) async {
    SigninResult result = await _service.signin(signinRequest);

    return result;
  }
}
