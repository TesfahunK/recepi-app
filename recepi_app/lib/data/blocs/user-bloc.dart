import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:recepi_app/data/appstate.dart';
import 'package:recepi_app/data/get-it.dart';
import 'package:recepi_app/utils/http-stuff.dart';
import 'package:recepi_app/utils/urls.dart' as urls;
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

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

  Future initAuth() async {
    // This method initiates the retrival and checking of an existing token
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

  Future _handleAuth(
      var decoded, bool remember, String password, String email) async {
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
  }

  Future login({String email, String password, bool remember}) async {
    await HttpBaby(loading: (lo) {
      _loggingIn.add(lo);
    }, onSuccess: (body) async {
      await _handleAuth(body, remember, password, email);
    }, onUnauthorized: (body) {
      _loginError.add("Invalid email or password");
    }).handlePostRequest(
        modelPath: "${urls.userPath}/login",
        body: {"email": email, "password": password});
  }

  Future createUser(String email, String password, BuildContext context) async {
    await HttpBaby(onSuccess: (body) async {
      //Success
      _signupError.add(null);
      await login(email: email, password: password, remember: false);
      Navigator.pop(context);
    }, onUnauthorized: (body) {
      //UnAuthenticated
      _signupError.add("email already exists");
    }).handlePostRequest(
        modelPath: urls.userPath, body: {"email": email, "password": password});
  }

  Future updatePassword({String oldpassword, String newpassword}) async {
    Map<String, String> _filter = {
      "access_token": _appstate.authdata.token,
    };

    await HttpBaby(onSuccess: (body) {}, onUnauthorized: (body) {})
        .handlePostRequest(
            modelPath: "${urls.userPath}/change-password",
            filter: _filter,
            body: {"oldPassword": oldpassword, "newPassword": newpassword});
  }

  Future logout() async {
    // Map<String, String> _filter = {
    //   "access_token": _appstate.authdata.token,
    // };
    // try {
    //   var response = await RequestBrokers.handlePostRequest(
    //       filter: _filter,
    //       baseUrl: urls.base,
    //       modelPath: urls.userPath,
    //       exactPath: "logout");

    //   if (response.statusCode == 204) {
    //     await _storage.write(key: "recipe_token", value: null);
    //     await _storage.write(key: "recipe_UserId", value: null);
    _isAuthenticated.add(false);
    //   }
    // } catch (e) {}
  }

  disposeAuth() {
    _isAuthenticated.close();
  }
}
