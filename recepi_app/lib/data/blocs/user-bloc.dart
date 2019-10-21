import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:recepi_app/data/appstate.dart';
import 'package:recepi_app/data/get-it.dart';
import 'package:recepi_app/utils/request-handlers.dart' as RequestBrokers;
import 'package:recepi_app/utils/urls.dart' as urls;
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;

class AuthData {
  String token;
  String userId;
  AuthData({this.token, this.userId});
}

final _appstate = getIt.get<AppState>();

// This controller class is responsible for actions related with User model , it also tracks the Authentication and token status
class UserBloc {
  final _isAuthenticated = new BehaviorSubject<bool>();
  final _loggingIn = new BehaviorSubject<bool>();
  final _loginError = new BehaviorSubject<String>();
  final _signupError = new BehaviorSubject<String>();
  AuthData _authdata = new AuthData();

  //Observables
  Observable<bool> get isAuthenticated => _isAuthenticated.stream;
  Observable<bool> get loggingIn => _loggingIn.stream;
  Observable<String> get loginError => _loginError.stream;
  Observable<String> get signupError => _signupError.stream;
  // getters
  AuthData get authdata => _authdata;
  final _storage = new FlutterSecureStorage();

// Methods
  Future initAuth() async {
    String _token = await _storage.read(key: "recipe_token");
    String _userid = await _storage.read(key: "recipe_UserId");
    if (_token != null) {
      _authdata = new AuthData(token: _token, userId: _userid);
      _isAuthenticated.add(true);
      _appstate.initApp();
    } else {
      _isAuthenticated.add(false);
    }
  }

  Future _handleAuth(http.Response response, bool remember, String password,
      String email) async {
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      if (remember) {
        _loginError.add(null);
        await _storage.write(key: "recepi_passphrase", value: password);
        await _storage.write(key: "recepi_mail", value: email);
        await _storage.write(key: "recepi_remember", value: "y");
        await _storage.write(key: "recipe_token", value: decoded['id']);
        await _storage.write(key: "recipe_UserId", value: decoded['userId']);
        this._authdata =
            AuthData(token: decoded['id'], userId: decoded['userId']);
        _appstate.initApp();
        _isAuthenticated.add(true);
      } else {
        _loginError.add(null);
        await _storage.write(key: "recepi_remember", value: "n");
        await _storage.write(key: "recipe_token", value: decoded['id']);
        await _storage.write(key: "recipe_UserId", value: decoded['userId']);
        this._authdata =
            AuthData(token: decoded['id'], userId: decoded['userId']);
        _appstate.initApp();
        _isAuthenticated.add(true);
      }
    } else if (response.statusCode == 401) {
      _loginError.add("Invalid email or password");
    }
  }

  Future login({String email, String password, bool remember}) async {
    _loggingIn.add(true);

    try {
      var response = await RequestBrokers.handlePostRequest(
          baseUrl: urls.base,
          modelPath: urls.userPath,
          exactPath: "login",
          body: {"email": email, "password": password});
      await _handleAuth(response, remember, password, email);
      _loggingIn.add(false);
    } catch (e) {
      _loggingIn.add(false);
    }
  }

  Future createUser(String email, String password, BuildContext context) async {
    try {
      var response = await RequestBrokers.handlePostRequest(
          baseUrl: urls.base,
          modelPath: urls.userPath,
          body: {"email": email, "password": password});
      if (response.statusCode == 200) {
        _signupError.add(null);
        await login(email: email, password: password, remember: false);
        Navigator.pop(context);
      } else if (response.statusCode == 401) {
        _signupError.add("email already exists");
      }
    } catch (e) {}
  }

  Future updatePassword({String oldpassword, String newpassword}) async {
    Map<String, String> _filter = {
      "access_token": _appstate.authdata.token,
    };
    try {
      var response = await RequestBrokers.handlePostRequest(
          filter: _filter,
          baseUrl: urls.base,
          modelPath: urls.userPath,
          exactPath: "change-password",
          body: {"oldPassword": oldpassword, "newPassword": newpassword});

      if (response.statusCode == 204) {
      } else if (response.statusCode == 400) {}
    } catch (e) {}
  }

  Future logout() async {
    Map<String, String> _filter = {
      "access_token": _appstate.authdata.token,
    };
    try {
      var response = await RequestBrokers.handlePostRequest(
          filter: _filter,
          baseUrl: urls.base,
          modelPath: urls.userPath,
          exactPath: "logout");

      if (response.statusCode == 204) {
        await _storage.write(key: "recipe_token", value: null);
        await _storage.write(key: "recipe_UserId", value: null);
        _isAuthenticated.add(false);
      }
    } catch (e) {}
  }

  disposeAuth() {
    _isAuthenticated.close();
  }
}
