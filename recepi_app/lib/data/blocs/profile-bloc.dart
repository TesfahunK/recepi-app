import 'dart:convert';
import 'dart:io';

import 'package:recepi_app/data/appstate.dart';
import 'package:recepi_app/data/get-it.dart';
import 'package:recepi_app/data/models/profile.dart';
import 'package:rxdart/rxdart.dart';
import 'package:recepi_app/utils/urls.dart' as urls;
import 'package:recepi_app/utils/request-handlers.dart' as RequestBroker;

final _appstate = getIt.get<AppState>();

class ProfileBloc {
//Prfofile Subjects
  final _profile = new BehaviorSubject<Profile>();
  final _hasProfile = new BehaviorSubject<bool>();
  final _loading = new BehaviorSubject<bool>.seeded(false);

//Observables
  Observable<Profile> get profile => _profile.stream;
  Observable<bool> get hasProfile => _hasProfile.stream;
  Observable<bool> get loadingProfile => _loading.stream;
//Getters
  Profile get profileValue => _profile.value;
  bool get getHasProfile => _hasProfile.value;
  bool get getProfileLoading => _loading.value;

//http Related methods
  Future createProfile({File image, Map<String, String> data}) async {
    try {
      Map<String, String> _filter = {
        "access_token": _appstate.authdata.token,
      };
      data.addAll({"userId": "User${_appstate.authdata.userId}"});
      var response = await RequestBroker.handlePostRequest(
          baseUrl: urls.base,
          modelPath: urls.profilePath,
          exactPath: "new",
          body: data,
          filter: _filter);
      if (response.statusCode == 200) {
        getProfile(mine: true);
      } else if (response.statusCode == 401) {
        _appstate.logout();
      }
    } catch (e) {}
  }

  Future getProfile({String id, bool mine}) async {
    _loading.add(true);
    try {
      String _id = mine ? _appstate.authdata.userId : id;
      Map<String, String> _filter = {
        "access_token": _appstate.authdata.token,
        "filter": json.encode({
          "where": {"userId": "User" + "$_id"},
          "include": [
            {"relation": "saved"}
          ]
        })
      };
      var response = await RequestBroker.handleGetRequest(
          baseUrl: urls.base,
          modelPath: urls.profilePath,
          exactPath: "findOne",
          filter: _filter);
      if (response.statusCode == 200) {
        var decoded = json.decode(response.body);
        _profile.add(Profile.fromMap(decoded));
        _hasProfile.add(true);
        _loading.add(false);
      } else if (response.statusCode == 401) {
        _loading.add(false);

        _appstate.logout();
      } else if (response.statusCode == 404) {
        _loading.add(false);

        _hasProfile.add(false);
      }
    } catch (e) {
      _loading.add(false);
    }
  }

  Future updateProfile({Map<String, dynamic> data}) async {
    try {
      Map<String, String> _filter = {
        "access_token": _appstate.authdata.token,
      };

      var response = await RequestBroker.handlePatchRequest(
          filter: _filter,
          baseUrl: urls.base,
          modelPath: urls.profilePath,
          id: _appstate.profileValue.id,
          body: data);
      var decoded = json.decode(response.body);

      if (response.statusCode == 200) {
        _profile.add(Profile.fromMap(decoded));
      }
    } catch (e) {
      print(e);
    }
  }
}
