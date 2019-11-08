import 'dart:convert';
import 'dart:io';

import 'package:recepi_app/data/appstate.dart';
import 'package:recepi_app/data/get-it.dart';
import 'package:recepi_app/data/models/profile.dart';
import 'package:recepi_app/utils/http-stuff.dart';
import 'package:rxdart/rxdart.dart';
import 'package:recepi_app/utils/urls.dart' as urls;

final _appstate = getIt.get<AppState>();

class ProfileBloc {
//Prfofile Subjects
  final _profile = new BehaviorSubject<Profile>();
  final _other = new BehaviorSubject<Profile>();
  final _hasProfile = new BehaviorSubject<bool>();
  final _loading = new BehaviorSubject<bool>.seeded(false);

//Observables
  Observable<Profile> get profile => _profile.stream;
  Observable<bool> get hasProfile => _hasProfile.stream;
  Observable<bool> get loadingProfile => _loading.stream;
//Getters
  Profile get profileValue => _profile.value;
  Profile get getOtherProfile => _other.value;
  bool get getHasProfile => _hasProfile.value;
  bool get getProfileLoading => _loading.value;

//http Related methods
  Future createProfile({File image, Map<String, String> data}) async {
    Map<String, String> _filter = {
      "access_token": _appstate.authdata.token,
    };
    data.addAll({"userId": "User${_appstate.authdata.userId}"});
    await HttpBaby(onSuccess: (body) {
      getProfile(mine: true);
    }, onUnauthorized: (body) {
      _appstate.logout();
    }).handlePostRequest(
        modelPath: urls.profilePath, body: data, filter: _filter);
  }

  Future getProfile({String id, bool mine}) async {
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

    await HttpBaby(onSuccess: (body) {
      if (mine == false) {
        _other.add(Profile.fromMap(body));
      } else {
        _profile.add(Profile.fromMap(body));
        _hasProfile.add(true);
      }
    }, loading: (loading) {
      _loading.add(loading);
    }, onNotFound: (body) {
      _hasProfile.add(false);
    }, onUnauthorized: (body) {
      _hasProfile.add(false);
    }).handleGetRequest(
        modelPath: "${urls.profilePath}/${mine ? "findOne" : id}",
        filter: mine
            ? _filter
            : {
                "access_token": _appstate.authdata.token,
              });
  }

  Future updateProfile({Map<String, dynamic> data}) async {
    Map<String, String> _filter = {
      "access_token": _appstate.authdata.token,
    };

    await HttpBaby(onSuccess: (body) async {
      await getProfile(mine: true);
    }).handlePatchRequest(
        filter: _filter,
        modelPath: "${urls.profilePath}/${_appstate.profileValue.id}",
        body: data);
  }
}
