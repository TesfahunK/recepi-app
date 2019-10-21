import 'dart:convert';
import 'dart:io';
import 'package:recepi_app/data/appstate.dart';
import 'package:recepi_app/data/get-it.dart';
import 'package:recepi_app/data/models/recepi.dart';
import 'package:recepi_app/utils/imagedecoder.dart';
import 'package:recepi_app/utils/request-handlers.dart' as RequestBroker;
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:recepi_app/utils/urls.dart' as urls;

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
    try {
      Map<String, dynamic> _mapped = recepi.tomap(
          recepi, _appstate.profileValue.id, await tobase64(image));
      Map<String, String> _filter = {
        "access_token": _appstate.authdata.token,
      };
      String _body = json.encode(_mapped);
      var response = await RequestBroker.handlePostRequest(
          filter: _filter,
          headers: {"content-type": "application/json"},
          baseUrl: urls.base,
          modelPath: urls.recepiPath,
          body: _body);

      if (response.statusCode == 200) {
        print("posted");
        getRecepies();
      }
    } catch (e) {}
  }

  List<Recepi> _recepisFactory(List list) {
    List<Recepi> _list = list.map((f) => Recepi.fromJson(f)).toList();
    return _list;
  }

  Future getRecepies() async {
    try {
      Map<String, String> _filter = {
        "access_token": _appstate.authdata.token,
        "filter": json.encode({
          "include": [
            {
              "relation": "profile",
              "scope": {
                "fields": ["name", "id", "img_url"]
              }
            }
          ]
        })
      };
      var response = await RequestBroker.handleGetRequest(
          filter: _filter, baseUrl: urls.base, modelPath: urls.recepiPath);
      if (response.statusCode == 200) {
        var decoded = json.decode(response.body);
        _recepis.add(_recepisFactory(decoded));
      } else {
        print(response.statusCode.toString());
      }
    } catch (e) {}
  }

  Future deleteRecepi(String id, Recepi recepi) async {
    try {
      Map<String, String> _filter = {
        "access_token": _appstate.authdata.token,
      };
      var response = await RequestBroker.handleDeleteRequest(
          filter: _filter,
          baseUrl: urls.base,
          modelPath: urls.recepiPath,
          exactPath: "$id");
      if (response.statusCode == 200) {
        _recepis.value.remove(recepi);
      } else if (response.statusCode == 401) {
        _appstate.logout();
      }
    } catch (e) {}
  }

  Future updateRecepi({String id, Map data}) async {
    try {
      Map<String, String> _filter = {
        "access_token": _appstate.authdata.token,
      };
      var response = await RequestBroker.handlePatchRequest(
          filter: _filter,
          baseUrl: urls.base,
          modelPath: urls.recepiPath,
          id: "$id");
      if (response.statusCode == 200) {
        var decoded = json.decode(response.body);
        _recepis.add(_recepisFactory(decoded));
      }
    } catch (e) {}
  }

  disposeRecepi() {
    _recepis.close();
    _fetching.close();
  }
}
