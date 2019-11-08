import 'dart:convert';
import 'dart:io';

import 'package:recepi_app/data/appstate.dart';
import 'package:recepi_app/data/get-it.dart';
import 'package:recepi_app/data/models/recepi.dart';
import 'package:recepi_app/utils/http-stuff.dart';
import 'package:recepi_app/utils/imagedecoder.dart';
import 'package:recepi_app/utils/urls.dart' as urls;
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

final _appstate = getIt.get<AppState>();

class RecepiBloc {
  final _recepis = new BehaviorSubject<List<Recepi>>.seeded([]);
  final _fetching = new BehaviorSubject<bool>.seeded(false);
  //observables
  Observable<List<Recepi>> get recepis => _recepis.stream;
  Observable<bool> get fetching => _fetching.stream;

  // getters
  List<Recepi> get getRecepis => _recepis.value;
  bool get getFetching => _fetching.value;

  Future createRecepi({Recepi recepi, File image}) async {
    Map<String, dynamic> _mapped =
        recepi.tomap(recepi, _appstate.profileValue.id, await tobase64(image));
    Map<String, String> _filter = {
      "access_token": _appstate.authdata.token,
    };
    String _body = json.encode(_mapped);
    await HttpBaby(onSuccess: (body) {
      getRecepies();
    }).handlePostRequest(
        filter: _filter,
        headers: {"content-type": "application/json"},
        modelPath: urls.recepiPath,
        body: _body);
  }

  List<Recepi> _recepisFactory(List list) {
    List<Recepi> _list = list.map((f) => Recepi.fromJson(f)).toList();
    return _list;
  }

  Future getRecepies() async {
    Map<String, String> _filter = {
      "access_token": _appstate.authdata.token,
      "filter": json.encode({
        "include": [
          {
            "relation": "profile",
            "scope": {
              "fields": ["name", "id", "birthdate"]
            }
          }
        ]
      })
    };
    await HttpBaby(
      loading: (lo) {
        _fetching.add(lo);
      },
      hasConnectionError: (meh) {
        print("Nooo");
      },
      onSuccess: (body) {
        _recepis.add(_recepisFactory(body));
      },
    ).handleGetRequest(filter: _filter, modelPath: urls.recepiPath);
  }

  Future deleteRecepi(String id, Recepi recepi) async {
    Map<String, String> _filter = {
      "access_token": _appstate.authdata.token,
    };
    await HttpBaby(onSuccess: (body) {
      _recepis.value.remove(recepi);
    }, onUnauthorized: (body) {
      _appstate.logout();
    }).handleDeleteRequest(
      filter: _filter,
      modelPath: "${urls.recepiPath}/$id",
    );
  }

  Future updateRecepi({String id, Map data}) async {
    Map<String, String> _filter = {
      "access_token": _appstate.authdata.token,
    };
    await HttpBaby(onSuccess: (body) {}).handlePatchRequest(
        filter: _filter, modelPath: "${urls.recepiPath}/$id", body: data);
  }

  disposeRecepi() {
    _recepis.close();
    _fetching.close();
  }
}
